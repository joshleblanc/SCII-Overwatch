@dir = "/home/josh/dev/sites/SCII-Overwatch/"

worker_processes 2
working_directory @dir

timeout 30

listen "#{@dir}tmp/sockets/unicorn.sock", backlock: 2048

stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"
