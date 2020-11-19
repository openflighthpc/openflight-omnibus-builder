# Using a Scheduler(7)

## What is a batch job scheduler?

Most existing HPC environments are managed by a job scheduler, also known as the batch scheduler, workload manager, queuing system or load-balancer. The scheduler allows multiple users to fairly share compute nodes, allowing system administrators to control how resources are made available to different groups of users. All schedulers are designed to perform the following functions:

 * Allow users to submit new jobs to the research environment
 * Allow users to monitor the state of their queued and running jobs
 * Allow users and system administrators to control running jobs
 * Monitor the status of managed resources including system load, memory available, etc.

When a new job is submitted by a user, the research environment scheduler software assigns compute cores and memory to satisfy the job requirements. If suitable resources are not available to run the job, the scheduler adds the job to a queue until enough resources are available for the job to run. You can configure the scheduler to control how jobs are selected from the queue and executed on research environment nodes, including automatically preparing nodes to run parallel MPI jobs. Once a job has finished running, the scheduler returns the resources used by the job to the pool of free resources, ready to run another user job.

## Types of batch job

Users can run a number of different types of job via the research environment scheduler, including:

 * Batch jobs; single-threaded applications that run only on one compute core
 * Array jobs; two or more similar batch jobs which are submitted together for convenience
 * SMP or multi-threaded jobs; multi-threaded applications that run on two or more compute cores on the same compute node
 * Parallel jobs; multi-threaded applications making use of an MPI library to run on multiple cores spread over one or more compute nodes

The research environment job-scheduler is responsible for finding compute nodes in your research environment to run all these different types of jobs on. It keeps track of the available resources and allocates jobs to individual groups of nodes, making sure not to over-commit CPU and memory.

## Interactive jobs

Users typically interact with compute research environments by running batch (also known as non-interactive) jobs. Sometimes though, you'll need to use an interactive job.

 * An interactive job is one that you directly control, either via a graphical interface or by typing at the command-prompt.
 * A batch job is run by writing a list of instructions that are passed to compute nodes to run at some point in the future.

Both methods of running jobs can be equally as efficient, particularly on a personal, ephemeral research environment. Both classes of job can be of any type - for example, it's possible to run interactive parallel jobs and batch multi-threaded jobs across your research environment. The choice of which class of job-type you want to use will depend on the application you're running, and which method is more convenient for you to use.

## Why use a job scheduler in an OpenFlight environment?

Good question. On shared multi-user research environments, a job-scheduler is often used as a control mechanism to make sure that users don't unfairly monopolise the valuable compute resources. In extreme cases, the scheduler may be wielded by system administrators to force “good behaviour” in a shared environment, and can feel like an imposition to research environment users.

With your own personal research environment, you have the ability to directly control the resources available for your job - you don't need a job scheduler to limit your usage.

However, there are a number of reasons why your own job-scheduler can still be a useful tool in your research environment:

 * It can help you organise multi-stage work flows, with batch jobs launching subsequent jobs in a defined process.
 * It can automate launching of MPI jobs, finding available nodes to run applications on.
 * It can help prevent accidentally over-allocating CPUs or memory, which could lead to nodes failing.
 * It can help bring discipline to the environment, providing a consistent method to replicate the running of jobs in different environments.
 * Jobs queued in the scheduler can be used to trigger scaling-up the size of your research environment, with compute nodes released from the research environment when there are no jobs to run, saving you money.
 * Your OpenFlight environment comes with a job-scheduler pre-installed, ready for you to start using. The scheduler uses very few resources when idle, so you can choose to use it if you find it useful, or run jobs manually across your research environment if you prefer.

## What's next?

Read about:

 * How to run jobs:
    `flight howto show run-jobs`

 * The useful suite of tools provided by the Flight User Suite:
    `flight howto show use-flight-user-suite`

You can find more help and documentation in the OpenFlight docs:

> <https://build.openflighthpc.org/>
> <https://use.openflighthpc.org/>

## License

This work is licensed under a Creative Commons Attribution-ShareAlike
4.0 International License.

See <http://creativecommons.org/licenses/by-sa/4.0/> for more
information.

Copyright (C) 2020 Alces Flight Ltd.
