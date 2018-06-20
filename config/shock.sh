#!/bin/bash

conf=conf.dat
mpi_size=8
nptl=20
ts=10
te=187
dist_flag=1      # 0 for Maxwellian. 1 for delta function.
split_flag=1     # 0 for without particle split, 1 for with split
whole_mhd_data=1 # whether to read the whole MHD data

track_particle_flag=0 # whether to track particles
nptl_selected=100     # number of selected particles to track
nsteps_interval=100   # steps interval to track particles

inject_at_shock=1

change_variable () {
    sed -i -e "s/\($1 = \).*/\1$2/" $conf
}

run_stochastic () {
    change_variable momentum_dependency $1
    change_variable pindex $2
    change_variable mag_dependency $3
    change_variable kpara0 $5
    change_variable kret $6
    # cat $conf
    cd ..
    diagnostics_directory=$7
    mkdir -p $diagnostics_directory
    srun -n $mpi_size ./stochastic-2dmhd.exec -dm $4 -np $nptl -ts $ts -te $te -df $dist_flag \
        -wm $whole_mhd_data -sf $split_flag -tf $track_particle_flag -ns $nptl_selected -ni $nsteps_interval \
        -dd $diagnostics_directory -is $inject_at_shock
    cd config
    # Change the parameters back 
    change_variable momentum_dependency 1
    change_variable pindex 1.3333333
    change_variable mag_dependency 1
    change_variable kpara0 0.01
    change_variable kret 0.03
}

stochastic () {
    # run_stochastic 1 1.0 0 $1 $2 p100_b000
    # run_stochastic 1 1.0 1 $1 $2 p100_b100
    # diagnostics_directory=data/$2/p000_b000_385_01/
    # run_stochastic 1 0.0 0 $1 38.5 0.1 $diagnostics_directory
    # diagnostics_directory=data/$2/p000_b000_385_003/
    # run_stochastic 1 0.0 0 $1 38.5 0.03 $diagnostics_directory
    diagnostics_directory=data/$2/p000_b000_1283_003/
    run_stochastic 1 0.0 0 $1 128.3 0.03 $diagnostics_directory
    # diagnostics_directory=data/$2/p000_b000_100/
    # run_stochastic 1 0.0 0 $1 1.00 $diagnostics_directory
    # diagnostics_directory=data/$2/p000_b000_1000/
    # run_stochastic 1 0.0 0 $1 10.00 $diagnostics_directory
    # diagnostics_directory=data/$2/p133_b000_001/
    # run_stochastic 1 1.3333333 0 $1 0.01 $diagnostics_directory
    # diagnostics_directory=data/$2/p133_b100_001/
    # run_stochastic 1 1.3333333 1 $1 0.01 $diagnostics_directory
    # diagnostics_directory=data/$2/p133_b000_01/
    # run_stochastic 1 1.3333333 0 $1 0.1 $diagnostics_directory
    # diagnostics_directory=data/$2/p133_b100_01/
    # run_stochastic 1 1.3333333 1 $1 0.1 $diagnostics_directory
    # diagnostics_directory=data/$2/p133_b000_0001/
    # run_stochastic 1 1.3333333 0 $1 0.001 $diagnostics_directory
    # diagnostics_directory=data/$2/p133_b100_0001/
    # run_stochastic 1 1.3333333 1 $1 0.001 $diagnostics_directory
}

# mhd_run_dir=/net/scratch3/xiaocanli/mhd/shock/bin_data/
# run_name=shock_interaction
# stochastic $mhd_run_dir $run_name
mhd_run_dir=/net/scratch3/xiaocanli/mhd/planar_shock/bin_data/
run_name=planar_shock
stochastic $mhd_run_dir $run_name
