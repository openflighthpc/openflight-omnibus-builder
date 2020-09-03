#!/bin/bash -l
#@      flight_JOB[name]: SMP multiple slot (Slurm)
#@      flight_JOB[desc]: Submit a job that has multiple processes where all processes need to reside on a single host.
#@ flight_JOB[copyright]: Copyright (C) 2020 Alces Flight Ltd.
#@   flight_JOB[license]: Creative Commons Attribution-ShareAlike 4.0 International
#==============================================================================
# Copyright (C) 2020 Alces Flight Ltd.
#
# This work is licensed under a Creative Commons Attribution-ShareAlike
# 4.0 International License.
#
# See http://creativecommons.org/licenses/by-sa/4.0/ for details.
#==============================================================================
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
#                        SLURM SUBMISSION SCRIPT
#                    AVERAGE QUEUE TIME: Short/Medium
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
#  >>>> OPERATIONAL DIRECTIVES - change these as required
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

#=====================
#  Working directory
#---------------------
# By default, your job will be executed in the directory from which
# you submitted the job.
#
# Alternatively, if you need to specify an explicit working
# directory for your job set a location here.
#
##SBATCH -D /home/%u/sharedscratch/

#=========================
#  Environment variables
#-------------------------
# When set to "ALL", this setting exports all variables present when
# the job is submitted.  Set to "NONE" to disable environment variable
# propagation, or a comma-separated list to be more selective.
#
#SBATCH --export=ALL

#================
#  Output files
#----------------
# Set an output file for messages generated by your job script
#
# Specify a path to a file to contain the output from the standard
# output stream of your job script. If you omit `-e` below,
# standard error will also be written to this file.
#
#SBATCH -o job-%j.output

# Set an output file for STDERR
#
# Specify a path to a file to contain the output from the standard
# error stream of your job script.
#
# This is not required if you want to merge both output streams into
# the file specified above.
#
##SBATCH -e job-%j.error

#============
#  Job name
#------------
# Set the name of your job - this will be shown in the process
# queue.
#
##SBATCH -J myjob

#=======================
#  Email notifications
#-----------------------
# Set the destination email address for notifications.  If not set,
# will send mail to the submitting user on the submission host.
#
##SBATCH --mail-user=your.email@example.com

# Set the conditions under which you wish to be notified.
# Valid options are: NONE, BEGIN, END, FAIL, REQUEUE, ALL (equivalent
# to BEGIN, END, FAIL, REQUEUE, and STAGE_OUT), STAGE_OUT (burst
# buffer stage out and teardown completed), TIME_LIMIT, TIME_LIMIT_90
# (reached 90 percent of time limit), TIME_LIMIT_80 (reached 80
# percent of time limit), TIME_LIMIT_50 (reached 50 percent of time
# limit) and ARRAY_TASKS (send emails for each array task). Multiple
# type values may be specified in a comma separated list.
# If not specified, will send mail if the job is aborted.
#
##SBATCH --mail-type ALL

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
#  >>>> RESOURCE REQUEST DIRECTIVES - always set these
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

#===================
#  Maximum runtime
#-------------------
# Expected RUNTIME
#
# Enter the expected runtime for your job.  Specification of a
# shorter runtime will cause the scheduler to be more likely to
# schedule your job sooner, but note that your job **will be
# terminated if it is still executing after the time specified**.
#
# A time limit of zero requests that no time limit be imposed.
# Format: one of "minutes", "minutes:seconds",
# "hours:minutes:seconds", "days-hours", "days-hours:minutes" and
# "days-hours:minutes:seconds". e.g. `3-0` for 3 days.
#SBATCH --time=3-0

#================
#  Memory limit
#----------------
# Expected HARD MEMORY LIMIT
#
# Enter the expected memory usage of your job.  Specification of a
# smaller memory requirement will cause the scheduler to be more
# likely to schedule your job sooner, but note that your job **may
# be terminated if it exceeds the specified allocation**.
#
# Note that:
#
#  1. You may specify a total amount of memory for the job using
#     `--mem`, or an amount of memory per CPU by specifying
#     `--mem-per-cpu`.
#
#  2. This setting is specified in megabytes. e.g. specify `1024` for
#     1 gigabyte.
#
#SBATCH --mem=1024

#==========================
#  Processing requirements
#--------------------------
# Specify the number of processing slots required for your job.
#
# You should request a processing slot for each simultaneous thread
# (or process) that your script and/or application executes.  Note
# that requesting a larger number of slots will mean that your job
# could take longer to launch.  Also note that you should avoid
# requesting more slots than are available on any one node as, in
# that situation, the scheduler will not be able to find any node on
# which to execute your job and **it will queue indefinitely**.
#
# Note that `--nodes=1` should be specified to ensure that all tasks
# are scheduled on a single node for a SMP job.
#
#SBATCH --nodes=1
#SBATCH --ntasks=4

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
#  >>>> SET TASK ENVIRONMENT VARIABLES
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
# If necessary, set up further environment variables that are not
# specific to your workload here.
#
# Several standard variables, such as SLURM_JOB_ID, SLURM_JOB_NAME and
# SLURM_NTASKS, are made available by the scheduler.

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
#  >>>> YOUR WORKLOAD
# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

#=======================
#  Environment modules
#-----------------------
# e.g.:
# module load apps/imb

#===========================
#  Create output directory
#---------------------------
# Specify and create an output file directory.

OUTPUT_PATH="$(pwd)/${SLURM_JOB_NAME}-outputs/$SLURM_JOB_ID"
mkdir -p "$OUTPUT_PATH"

#===============================
#  Application launch commands
#-------------------------------
# Customize this section to suit your needs.

echo "Executing job commands, current working directory is $(pwd)"

# REPLACE THE FOLLOWING WITH YOUR APPLICATION COMMANDS

echo "This is an example job. It was allocated $SLURM_NTASKS slot(s) on host `hostname -s` (as `whoami`)." > $OUTPUT_PATH/test.output
echo "Output file has been generated, please check $OUTPUT_PATH/test.output"
