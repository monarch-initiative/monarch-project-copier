test:
    rm -rf tmp/test-project || echo fresh
    copier copy --defaults --trust . tmp/test-project
    cd tmp/test-project && just && just setup && just test && uv run my-awesome-tool --help && uv run my-awesome-tool --name You

test-interactive:
    rm -rf tmp/test-project2 || echo fresh
    copier copy --trust . tmp/test-project2
    cd tmp/test-project && just && just setup && just test
    
