start:
    bin/bridgetown start --bind 0.0.0.0

build:
    npm run esbuild
    bin/bridgetown build

install:
    bundle install
    bundle binstubs bridgetown-core --force
    npm install

console:
    bin/bridgetown console

clean:
    bin/bridgetown clean
