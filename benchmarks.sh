#!/bin/bash
benchmark_run () {
    mpiexec -n 1 \
    -x UNIDIST_CPUS=$UNIDIST_CPUS \
    -x UNIDIST_MPI_HOSTS=$UNIDIST_MPI_HOSTS \
    --host $OPEN_MPI_HOST \
    --prefix /home/ubuntu/miniconda3/envs/timedf-openmpi \
    python timedf/scripts/benchmark_run.py $1 \
    -data_file /home/ubuntu/benchmark_datasets/$1 \
    -pandas_mode Modin_on_unidist_mpi \
    -verbosity 1 \
    -iterations 5 \
    -no_ml \
    -commit_unidist $UNDISIT_COMMIT \
    -num_threads $UNIDIST_CPUS \
    -unidist_hosts $UNIDIST_MPI_HOSTS \
    -db_name db.sqlite
}

for branch in "FEAT#308"
do
    git --git-dir /home/ubuntu/unidist/.git checkout $branch
    UNDISIT_COMMIT=$(git --git-dir /home/ubuntu/unidist/.git rev-parse HEAD)

    UNIDIST_MPI_HOSTS=host1
    OPEN_MPI_HOST=host1:32
    UNIDIST_CPUS=30
    # benchmark_run census
    benchmark_run ny_taxi
    # benchmark_run plasticc
    

    UNIDIST_MPI_HOSTS=host1
    OPEN_MPI_HOST=host1:62
    UNIDIST_CPUS=60
    # benchmark_run census
    benchmark_run ny_taxi
    # benchmark_run plasticc

    UNIDIST_MPI_HOSTS=host1,host2
    OPEN_MPI_HOST=host1:17,host2:17
    UNIDIST_CPUS=30
    # benchmark_run census
    # benchmark_run ny_taxi
    # benchmark_run plasticc

    UNIDIST_MPI_HOSTS=host1,host2
    OPEN_MPI_HOST=host1:32,host2:32
    UNIDIST_CPUS=60
    # benchmark_run census
    # benchmark_run ny_taxi
    # benchmark_run plasticc
done
