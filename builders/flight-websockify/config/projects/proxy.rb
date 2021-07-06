#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
#
# This file is part of OpenFlight Omnibus Builder.
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
# For more information on OpenFlight Omnibus Builder, please visit:
# https://github.com/openflighthpc/openflight-omnibus-builder
#===============================================================================
# Usually changing the main project file causes all dependencies to be
# rebuilt.
#
# Instead, this file can be used as the project build file and allows
# building of dependencies once while iterations are made on the main
# project file. e.g.:
#
#   bin/omnibus build proxy
#
# To force dependencies to be recompiled, increment the following
# number (which casues the checksum of this project file to change,
# resulting in the cache being dirtied and all dependencies being
# rebuilt).
#
# PROXY-BUILD-01
#
eval(File.read(File.expand_path('flight-websockify.rb', __dir__)), binding, __FILE__)
