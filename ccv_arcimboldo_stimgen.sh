#!/bin/bash
n_machines=500
# 500 for task1 5000 for task2
script_name='stimgen_ccv_task1' 
save_path='/gpfs/data/tserre/data/arcimboldo_stim/256_new/task1/'

# submit job
PARTITION='batch' # batch # bibs-smp # bibs-gpu # gpu # small-batch
QOS='bibs-tserre-condo' # pri-jk9

for i_machine in $(seq 1 $n_machines); do
sbatch -J "$script_name[$i_machine]" <<EOF
#!/bin/bash
#SBATCH -p $PARTITION
#SBATCH -n 4
#SBATCH -t 1:30:00
#SBATCH -g 1
#SBATCH --mem=16G
#SBATCH --begin=now
#SBATCH --qos=$QOS
#SBATCH --output=/gpfs/scratch/jk9/slurm/slurm-%j.out
#SBATCH --error=/gpfs/scratch/jk9/slurm/slurm-%j.out

echo "Starting job $i_machine on $HOSTNAME"
LC_ALL=en_US.utf8 \
matlab -nodesktop -nosplash -r \
"tic; $script_name($i_machine,$n_machines,'$save_path'); toc; exit"
EOF
done
