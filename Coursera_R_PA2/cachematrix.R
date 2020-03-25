## Put comments here that give an overall description of what your
## functions do

## This function creates a special "matrix" object (a vector) with methods (setm, getm, seti, geti) that provide access to the provided matrix and its inverse along with setting the same objects.
makeCacheMatrix <- function(x = matrix()) {
        i <- NULL
        setm <- function(y) {
                m <<- y
                i <<- NULL
        }
        getm <- function() m
        seti <- function(inv) i <<- solve(inv)
        geti <- function() i
        list(setm = setm, getm = getm, seti = seti, geti = geti)
}

## This function takes the special "matrix" object (a vector) provided by the makeCacheMatrix function and checks to see if the inverse of the matrix is available.  If so, uses it else sets it to be cached for subsequent calls.
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
        m <- x$getm()
        i <- x$geti()
        if(!is.null(i)) {
                message("getting cached data")
                return(i)
        } else {
          i <- solve(m)
          x$seti(i)
        }
}
