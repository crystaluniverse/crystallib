module installers

import cli
import os
import despiegk.crystallib.builder
import despiegk.crystallib.myconfig
import despiegk.crystallib.process
import despiegk.crystallib.nodejs

pub fn main(cmd cli.Command) ? {
	cfg := myconfig.get() ?

	flags := cmd.flags.get_all_found()

	ourreset := flags.get_bool('reset') or { false }
	clean := flags.get_bool('clean') or { false }

	println('INSTALLER:')

	if ourreset {
		println(' - reset the full system')
		reset() or { return error(' ** ERROR: cannot reset. Error was:\n$err') }
	}
	base() or { return error(' ** ERROR: cannot prepare system. Error was:\n$err') }

	sites_download(cmd, true) or {
		return error(' ** ERROR: cannot get web & wiki sites. Error was:\n$err')
	}

	nodejs.install(cfg) or { return error(' ** ERROR: cannot install nodejs. Error was:\n$err') }

	if clean {
		sites_cleanup(cmd) or { return error(' ** ERROR: cannot cleanup sites. Error was:\n$err') }
	}

	sites_install(cmd) or { return error(' ** ERROR: cannot install sites. Error was:\n$err') }
}

pub fn base() ? {
	myconfig := myconfig.get() ?
	base := myconfig.paths.base

	mut node := builder.node_get({}) or {
		return error(' ** ERROR: cannot load node. Error was:\n$err')
	}
	node.platform_prepare() ?

	if !os.exists(base) {
		os.mkdir(base) or { return err }
	}

	println(' - installed base requirements')
}

pub fn config_get(cmd cli.Command) ?myconfig.ConfigRoot {
	mut cfg := myconfig.get() ?

	flags := cmd.flags.get_all_found()
	cfg.pull = flags.get_bool('pull') or { false }
	cfg.reset = flags.get_bool('reset') or { false }

	if !os.exists(cfg.paths.code) {
		os.mkdir(cfg.paths.code) or { return err }
	}
	return cfg
}

pub fn reset() ? {
	myconfig := myconfig.get() ?
	base := myconfig.paths.base
	assert base.len > 10 // just to make sure we don't erase all
	script := '
	set -e
	rm -rf $base
	'
	process.execute_silent(script) or {
		println('** ERROR: cannot reset the system.\n$err')
		exit(1)
	}
	println(' - removed the ~/.publishtools')
}

pub fn publishtools_update() ? {
	script := '
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/crystaluniverse/publishtools/development/scripts/install.sh)"
	'
	process.execute_silent(script) ?
	println(' -update done')
}
