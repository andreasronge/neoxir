defmodule Mix.Tasks.Neoxir do

  defmodule Install do
    use Mix.Task

    @download_file "neo4j.tar.gz"

    def run(args) do
      Mix.shell.cmd "mkdir -p downloads"
      #Mix.shell.cmd "wget http://dist.neo4j.org/neo4j-community-2.1.6-unix.tar.gz -O downloads/neo4j.tar.gz"
      Mix.shell.cmd "cd downloads; tar xfz #{@download_file}"
      IO.puts (inspect args)
      Mix.shell.info "hello"
    end

  end

end