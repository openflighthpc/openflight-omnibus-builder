#==============================================================================
# Copyright (C) 2019-present Alces Flight Ltd.
#
# This file is part of Alces Flight Omnibus Builder.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# This project is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with this project. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Alces Flight Omnibus Builder, please visit:
# https://github.com/alces-flight/alces-flight-omnibus-builder
#===============================================================================

# TODO: Eventually package certbot with the app and remove this condition
unless system('which certbot 2>/dev/null 1>&2')
  $stderr.puts <<~ERROR
    Generating certificates requires 'certbot' to be installed!
    Please contact your system administrator for further assistance
  ERROR
  exit 1
end

require 'yaml'
require 'fileutils'

module FlightWWW
  class Config < Hashie::Dash
    include Hashie::Extensions::IgnoreUndeclared

    def self.root_join(*a)
      File.join(ENV['flight_ROOT'] || raise('Missing flight_ROOT!') , *a)
    end

    CONFIG_PATH = root_join('etc/www/cert-gen.yaml')

    def self.read
      data = if File.exists? CONFIG_PATH
        YAML.load File.read(CONFIG_PATH), symbolize_names: true
      else
        {}
      end
      new(**data)
    end

    def self.update
      read.tap do |config|
        init = config.to_h.dup
        yield config
        if (data = config.to_h) != init
          File.write CONFIG_PATH, YAML.dump(data)
        end
      end
    end

    property :letsencrypt_email
    property :letsencrypt_domain
    property :cert_type

    def lets_encrypt?
      resolved_cert_type == :lets_encrypt
    end

    def self_signed?
      resolved_cert_type == :self_signed
    end

    def cert_type?
      !(cert_type.nil? || cert_type.empty?)
    end

    def letsencrypt_email?
      !(letsencrypt_email.nil? || letsencrypt_email.empty?)
    end

    def letsencrypt_domain?
      !(letsencrypt_domain.nil? || letsencrypt_domain.empty?)
    end

    # NOTE: This method must not be cached! The config is a dynamic object that
    # is updated by scripts. This method must reflect these changes
    def resolved_cert_type
      case cert_type.to_s
      when 'lets-encrypt', 'lets_encrypt', 'letsencrypt'
        :lets_encrypt
      when 'self-signed', 'self_signed', 'selfsigned', ''
        # NOTE: unset values default to :self_signed without error
        :self_signed
      else
        $stderr.puts <<~WARN.chomp
          An unexpected error has occurred!
          The previously cached certificate type is unrecognized: #{cert_type}
          Attempting to fallback onto self-signed, your mileage may vary
        WARN
        self.cert_type = 'self_signed'
        :self_signed
      end
    end
  end
end

