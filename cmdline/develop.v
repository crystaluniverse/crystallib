module cmdline
import cli
import myconfig
import installers
import publishermod

fn develop (cmd  &cli.Command) ? {

	webrepo := cmd.flags.get_string('repo') or { '' }

	if webrepo == '' {
		installers.sites_download(cmd, false) ?
		mut cfg := myconfig.get(true) ?
		println(cfg)
		panic('we')
		mut publ := publishermod.new(cfg.paths.code) or { panic('cannot init publisher. $err') }
		publ.check()
		publ.develop = true
		cfg.update_staticfiles(false) ?
		publishermod.webserver_run(publ, cfg) // would be better to have the develop
	} else {
		installers.website_develop(cmd) ?
	}

}