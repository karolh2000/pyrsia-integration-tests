#!/bin/bash

# start the pyrsia node (no bootstrap?, single node)
chmod +x /src/pyrsia/target/debug/pyrsia_node
RUST_LOG=pyrsia=debug /src/pyrsia/target/debug/pyrsia_node --host 0.0.0.0 --listen /ip4/0.0.0.0/tcp/44000  --listen-only true

