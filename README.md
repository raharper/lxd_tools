Getting Started
---------------

1. Install lxd and chech that it's working by following the getting started
guid.
2. run ./setup.sh from in tree to prep host for testing

Tests
-----

There are two tests, create_and_delete_pylxd, and create_pylxd_overlay The only
difference between the two is that the latter does not stop and delete the
instance.  This is useful for debugging and for limit density tests.

It's best to check that the create_and_delete is working:

    sudo ./create_and_delete_pylxd test1
    1428421302.344413989 Cloning test1
    1428421302.428151020 Starting test1
    1428421302.464650798: test1 container_init() ->
    1428421302.486832770: test1 container_init() <-
    1428421302.489644348: test1 c.start() ->
    1428421302.509369004: test1 not running, calling c.start() ->
    1428421303.033891514: test1 state=running
    1428421303.039484133 Running 2 commands
    Ubuntu 14.04.2 LTS \n \l
    
     15:41:43 up  1:03,  0 users,  load average: 0.01, 0.05, 0.05
    1428421303.100174183 Stopping test1
    1428421303.191919773 test1 STOPPED
    1428421303.194327578 test1 Deleting test1
    Deleted test1
    1428421303.953419947 test1 DONE


Once one is working, start breaking it with scale:

CnD 10 containers, up to 4 at a time.

    seq -w 01 10 | time parallel -j 4 --progress sudo ./create_and_delete_pylxd

The -j parameter tells parallel how many execs in parallel, up to a host max of
255.

The current limit for breaking lxd is here:

    seq -w 01 50 | time parallel -j 25 --progress sudo ./create_and_delete_pylxd

That usually will wedge things.  While this is running, it's also useful to 
spin up a few watches, like:

    watch -d 0.5 ./api GET /1.0/containers

and

    watch -d 0.5 lxc list

and

    watch -d 0.5 grep -c overlay /proc/mounts


Cleanup
-------

Containers will wedge and overlay mounts will stick around.  Messy.
Here's how to revert/reset back to sane state.

    ./stop_all-pylxd
    for x in $(seq -w 01 50); do sudo ./delete-overlay ${x}; done

Note that the range of seq will need to be a superset of the the numbers.
Another note of caution, be wary of running seq with a range that increases
the number of digits , like seq -w 01 100 -- this will produce 001 .. 100,
instead of 01..99, and then 100.

