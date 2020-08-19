# How To Get Started

## What is OpenFlightHPC?

OpenFlightHPC is a software environment designed to help researchers and scientists run their own high-performance compute research environment quickly and easily. The basic structure of an OpenFlight environment is:

 * An access (login) node, plus a number of compute nodes
 * An Enterprise Linux operating system
 * A shared filesystem, mounted across all nodes
 * A batch job scheduler
 * Access to various libraries of software applications

OpenFlightHPC is designed to get researchers started with HPC as quickly as possible, providing a pre-configured environment which is ready for work immediately. The research environment you build is personal to you - you have root-access to the environment, and can setup and configure the system to your needs.

Your research environment is designed to be ephemeral - i.e. you run it for as long as you need it, then shut it down. Although there is no built-in time limit for OpenFlight research environments, the most effective way of sharing compute resources in the cloud is to book them out only when you need them. Contrary to popular belief, you can achieve huge cost savings over purchasing server hardware if you learn to work effectively in this way.

## Who is it for?

OpenFlight environments are designed for use by end-users - the scientists, researchers, engineers and software developers who actually run compute workloads and process data. This documentation is designed to help you to get the best out your environment, without needing assistance from teams of IT professionals.  OpenFlightHPC provides tools which enable you to service yourself - it's very configurable, and can be expanded to deliver a scalable platform for computational workloads.

## What doesn't it do?

An important part of having ultimate power to control your environment is taking responsibility for it. While no one is going to tell you how you should configure your research environment, you need to remember good security practice, and look after both your personal and research data. OpenFlight provides you with a personal, single-user research environment and is not indended as a replacement for your national super-computer centre.

If you're running OpenFlight on AWS, then there are some great tutorials written by the Amazon team on how to secure your environment. Just because you're running on public cloud, doesn't mean that your research environment is any less secure than a research environment running in your basement. Start at the _AWS Security Pages, <https://aws.amazon.com/security>_, and talk to a security expert if you're still unsure.

## Where can I get help?

This documentation is designed to walk you through how to get started with your OpenFlight environment. Capable users with some experience can be up and running in a handful of minutes - don't panic if it takes you a little more time, especially if you've not used Linux or HPC research environments before. Firstly, don't worry that you might break something complicated and expensive; one of the joys of having your own personal environment is that no one will tell you that you're doing it wrong, and nothing is at risk of being broken, aside from the data and work you've done yourself in the environment.

We encourage new users to run through a few tutorials in this documentation even if you have plenty of HPC experience. Technology moves forward all the time and new features are constantly popping up that could save you effort in future. If you do run into problems, try replicating the steps you went through to get where you are - sometimes a typo in a command early on in your workflow might not cause any errors until right at the end of your work. It can help to work collaboratively with other researchers running similar jobs - not only are two sets of eyes better than one, you'll both get something out of working together to achieve a shared goal.

There is an _OpenFlight community site, <https://community.openflighthpc.org/>_, for requesting support with OpenFlightHPC software, designed to help users share their experiences of running OpenFlight research environments, report any bugs with the software, and share knowledge to help everyone work more effectively. There is no payment required for using this service, only the general requirement to be nice to each other - if you find the site useful, then please pay the favour back by helping another user with their problem.

The OpenFlight community site is a great resource for helping with HPC research environment usage, but for software application support you're going to need to contact the developers of the packages themselves. Remember that many of these software products are open source and you've paid no fee to use them - try to make your bug reports and enhancement requests as helpful and friendly as possible to the application developers. They've done you a great service by making their software available for you to use - please be respectful of their time and effort if you need to contact them, and remember to credit their software in your research publications.

## What's next?

Read about:

 * How to get started with the Flight Environment:
    `flight howto show work-with-the-flight-environment`

* The useful suite of tools provided by the Flight User Suite:
   `flight howto show use-flight-user-suite`

 * How to run jobs:
    `flight howto show run-jobs`
    `flight howto show use-a-scheduler`

You can find more help and documentation in the OpenFlight docs:

> <https://build.openflighthpc.org/>
> <https://use.openflighthpc.org/>

## License

This work is licensed under a Creative Commons Attribution-ShareAlike
4.0 International License.

See <http://creativecommons.org/licenses/by-sa/4.0/> for more
information.

Copyright (C) 2020 Alces Flight Ltd.
