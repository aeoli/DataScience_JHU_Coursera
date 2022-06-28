# Programming assignment - Week 3- R Programming 
# Use the given examples and the function solve() -instead of mean()- to invert the given matrix


## FUNCTIONS
makeCacheMatrix <- function(x = matrix()) {
  
  # Quality check 1: input matrix must be squared
  if(dim(x)[1] != dim(x)[2]){
    message("Input matrix must be squared (dim = n x n)")
  }
  
  # Quality check 2: the determinats should not be 0
  else if(det(x) == 0){
    message("Input matrix must not be singular (det != 0)")
  }
  
  else{
    # Initialize i as NULL
    i <- NULL
    
    # FUN to set the matrix in the cache
    set <- function(s) {
      x <<- s
      i <<- NULL
    }
    
    # FUN to get the input matrix
    get <- function() x
    
    # FUN to set the inverse of the input matrix in the cache
    set_inverse <- function(inverse) i <<- inverse
    
    # FUN to get the inverse of the input matrix
    get_inverse <- function() i
    
    # Store the 4 FUNs as a list
    list(set = set, 
         get = get,
         setinv = set_inverse,
         getinv = get_inverse)
  }
}


cacheSolve <- function(x, ...) {
  # Check if the inverted matrix is already stored
  i <- x$getinv()
  
  # If yes, print it out from the cached data
  if(!is.null(i)) {
    message("getting cached data")
    return(i)
  }
  
  # If not, get the input matrix
  data <- x$get()
  
  # Invert the input matrix
  i <- solve(data, ...)
  
  # Store the input matrix and print it out
  x$setinv(i)
  i
}


## MATRIX EXAMPLES
M <- matrix(1:9,3,3) # singular matrix
M <- matrix(1:6,2,3) # not squared matrix
M <- matrix(6:9,2,2) # example 1
M <- matrix(rnorm(16),4,4) # example 2

## RUN
Mc <- makeCacheMatrix(M)
cacheSolve(Mc)



