# Real-time-Collaborative-Markdown-Editor
This is a multi-user collaborative document editor — a command-line, slimmed-down Google Docs.

## Description

I built a multi-user collaborative document editor — a command-line, slimmed-down Google Docs. The server stores the document and queues each client operation (insert, delete, bold, etc.), then broadcasts the results so everyone stays in sync. Documents are saved as plain text in a simplified Markdown-like format.

## Details
 ·Designed and shipped a fully-functioning client-server architecture in pure C: the server
 spawns spawns one POSIX thread per client plus a broadcast thread, enabling dozens of
 users to edit the same document concurrently without blocking.
 
 ·Implemented low-latency inter-process communication with realtime signals for the initial
 handshake and bidirectional named FIFOs for the data stream, avoiding sockets and keeping
 the solution portable on standard Linux.
 
 ·Engineered an efficient, copy-on-write document model based on a linked-list of chunk
 nodes; inserts, deletes and formatting changes run in O(1)–O(n) without shifting large
 buffers.
 
 ·Built conflict-free operational semantics and per-version history: each command carries a
 target version; the server time-orders commands, resolves cursor shifts, then atomically
 increments the version before broadcasting, guaranteeing consistency across clients.
 
 ·Addedsmart Markdown features such as automatic ordered-list renumbering, block-level
 formatting detection, and cursor-aware newline / heading logic, all handled server-side.
 
 ·Enforced role-based access control (read vs write) via a roles.txt lookup and permission
 checks on every command, preventing unauthorised edits. server_helpers
 
 ·Instrumented comprehensive logging and debug tooling (DOC?, LOG?, PERM?) as well as
 graceful shutdown that persists the latest document to doc.md.
 
 ·Hard-ned memory-safe, race-free implementation: all shared structures are protected with
 mutexes; custom alloc/free paths eliminate leaks detected by sanitizers. server_helpers
 
 ## Technologies & concepts used
 
 ·C11/POSIX APIs: pthread, realtime signal(7), mkfifo, nanosleep, sigaction.
 ·Concurrent programming: per-client queues, mutex-guarded critical sections,
role-based authorisation, detailed error codes.
 ·Logging & observability: thread-safe in-memory log linked list with runtime
 inspection commands.

 ## How to use it?
 
 How to Use (Quick 6 Steps)
1. Build

'make'    # Produces ./server and ./client

2. Start the server

'./server doc.txt <TIME_INTERVAL>'
Then you the server pid will be shown on the screen.

3. Start a client

Use the pid just shown and enter:
'./client <server_pid> <username>'

4. Start more client(optional)

5. Enter edit commands in the client side, e.g.

'INSERT <pos> <text>
DEL <start> <len>
BOLD <start> <END>
LOG?
DOC?'

6. Stay in sync
The client periodically pulls (or the server pushes) new versions; your view refreshes so everyone sees the same state.

7. Exit

With command 'DISCONNECT' to disconnect client with server.
After all clients are disconnected, enter 'QUIT' in Server side to quit the server.
or just close the client process (Ctrl+C).
 
