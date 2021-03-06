module gittools

pub enum GitStatus {
	unknown
	changes
	ok
	error
}

[heap]
struct GitStructure {
	multibranch bool
pub mut:
	root  string	
	repos []GitRepo
}

struct GitRepo {
	id int [skip]
	//only use when custom path
	path string
mut:
	gitstructure &GitStructure
pub mut:
	addr  GitAddr
	state GitStatus
}

struct GitAddr {
	root string
pub mut:
	provider string
	account  string
	name     string // is the name of the repository
	path     string // path in the repo (not on filesystem)
	branch   string
	anker    string // position in the file
	depth    int    // 0 means we have all depth
}
