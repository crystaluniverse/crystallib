module cmdline
import cli
import myconfig
import gittools
import os

pub fn get_config(cmd cli.Command) ?myconfig.ConfigRoot {
	mut cfg := myconfig.get(true) ?

	flags := cmd.flags.get_all_found()	
	cfg.pull = flags.get_bool("pull")or{false}
	cfg.reset = flags.get_bool("reset")or{false}

	if !os.exists(cfg.paths.code) {
		os.mkdir(cfg.paths.code) or { return err }
	}
	return cfg
}


fn get_config_gittools (cmd  &cli.Command) ? (myconfig.ConfigRoot,gittools.GitStructure) {

	mut cfg := get_config(cmd) ?
	mut gt := gittools.new(cfg.paths.code) or { return error('cannot load gittools:$err') }

	return cfg,gt

}