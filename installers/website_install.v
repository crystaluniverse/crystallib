module installers

// import os
// import myconfig
// import process
// import gittools
// import texttools

// // Initialize (load wikis) only once when server starts
// pub fn website_install(name string, first bool, conf &myconfig.ConfigRoot) ? {
// 	base := conf.paths.base
// 	codepath := conf.paths.code
// 	nodejspath := conf.nodejs.path

// 	mut gt := gittools.new(codepath) or { return error('ERROR: cannot load gittools:$err') }
// 	reponame := conf.reponame(name) ?
// 	mut repo := gt.repo_get(name: reponame) or { return error('ERROR: cannot load gittools:$err') }
// 	println(' - install website on $repo.path')

// 	if conf.reset {
// 		script6 := '
		
// 		cd $repo.path

// 		rm -rf modules
// 		rm -f .installed
// 		rm -f src/errors.md

// 		'
// 		println('   > reset')
// 		process.execute_silent(script6) or {
// 			return error('cannot install node modules for ${name}.\n$err')
// 		}
// 	}

// 	if conf.pull {
// 		script7 := '
		
// 		cd $repo.path

// 		git pull

// 		'
// 		println('   > pull')
// 		process.execute_silent(script7) or { return error('cannot pull code for ${name}.\n$err') }
// 	}

// 	if os.exists('$repo.path/.installed') {
// 		return
// 	}

// 	script_install := '

// 	set -e

// 	cd $repo.path

// 	rm -f yarn.lock
// 	rm -rf .cache		
	
// 	set +e
// 	source $base/nvm.sh
// 	set -e

// 	if [ "$first" = "true" ]; then
// 		nvm use --lts
// 		npm install
// 		rsync -ra --delete node_modules/ $base/node_modules/
// 	else
// 		rsync -ra --delete $base/node_modules/ node_modules/ 
// 		nvm use --lts
// 		npm install
// 	fi



// 	'

// 	if nodejspath.len == 0 {
// 		panic('nodejspath needs to be set')
// 	}

// 	script_run := '

// 	set -e
// 	cd $repo.path

// 	#need to ignore errors for getting nvm not sure why
// 	set +e
// 	source $base/nvm.sh

// 	set -e
// 	nvm use --lts

// 	export PATH=$nodejspath/bin:\$PATH

// 	gridsome develop

// 	'

// 	script_build := '

// 	set -e
// 	cd $repo.path

// 	#need to ignore errors for getting nvm not sure why
// 	set +e
// 	source $base/nvm.sh

// 	set -e
// 	nvm use --lts

// 	export PATH=$nodejspath/bin:\$PATH

// 	set +e
// 	gridsome build

// 	set -e

// 	mkdir -p $conf.paths.publish/$name
// 	rsync -ra --delete $repo.path/dist/ $conf.paths.publish/$name/

// 	cd $repo.path/dist

// 	#echo go to http://localhost:9999/
//  	#python3 -m http.server 9999

// 	'

// 	os.write_file('$repo.path/install.sh', texttools.dedent(script_install)) or {
// 		return error('cannot write to $repo.path/install.sh\n$err')
// 	}
// 	os.write_file('$repo.path/run.sh', texttools.dedent(script_run)) or {
// 		return error('cannot write to $repo.path/run.sh\n$err')
// 	}
// 	os.write_file('$repo.path/build.sh', texttools.dedent(script_build)) or {
// 		return error('cannot write to $repo.path/build.sh\n$err')
// 	}

// 	os.chmod('$repo.path/install.sh', 0o700)
// 	os.chmod('$repo.path/run.sh', 0o700)
// 	os.chmod('$repo.path/build.sh', 0o700)

// 	println('   > node modules install')
// 	process.execute_silent(script_install) or {
// 		return error('cannot install node modules for ${name}.\n$err')
// 	}

// 	// println(job)

// 	// process.execute_silent("mkdir -p $repo.path/content") ?

// 	for x in ['blog', 'person', 'news', 'project'] {
// 		if os.exists('$repo.path/content') {
// 			process.execute_silent('rm -rf $repo.path/content/$x\n') ?
// 			os.symlink('$codepath/github/threefoldfoundation/data_threefold/content/$x',
// 				'$repo.path/content/$x') or {
// 				return error('Cannot link $x from data path to repo path.\n$err')
// 			}
// 		}
// 	}

// 	os.write_file('$repo.path/.installed', '') or {
// 		return error('cannot write to $repo.path/.installed\n$err')
// 	}
// }
