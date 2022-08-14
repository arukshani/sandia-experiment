import os
import subprocess

def collect_iperf_logs(exp_obj, exp_template, workload):
    print("collect_iperf_server_logs")
    server_file_path = '/tmp/iperf-server-{}-r{}-{}.csv'.format(exp_obj.id, exp_obj.iteration, exp_obj.exp_time)
    cmd = 'scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i {} {}@{}:{} /tmp/'.format(
        exp_template['key_filename'],
        exp_template['username'],
        exp_template['server_list_wan'][0],
        os.path.join('/tmp', server_file_path))

    print('Copying remotepath {} to localpath {}'.format(server_file_path, '/tmp'))
    subprocess.run(cmd, check=True, shell=True,
                    stdout = subprocess.DEVNULL,
                    stderr=subprocess.PIPE)
    #Copy client logs only if its on a remote location
    print("collect_iperf_client_logs")

def collect_memcached_logs(exp_obj, exp_template, workload):
    print("collect_memcached_logs")