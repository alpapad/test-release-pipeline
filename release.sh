# Get latest tag so we get next version
mvn ci-friendly-flatten:version   # but can be done via git | sort |  head and some groovy magic... 
REV=$(cat revision.txt)
echo "Next release version is: ${REV}"

# Set new version
echo "Updating pom to: ${REV}"
mvn versions:set -DnewVersion=${REV}

# Do the usual release staff here: test, run sonar etc.. If release is OK it will move to next step
echo "Building, testing, etc"
mvn clean package -Drevision=${REV} # or mvn clean deploy ..

# Assuming we reached this point, we can release... 
echo "Adding pom.xml to commit & commit"
git add pom.xml # Add ONLY the pom
git commit -m "Release ${REV}" #Commit

mvn ci-friendly-flatten:scmTag  # Create and push tag (can also be done via git...)

# Do not push to develop...
