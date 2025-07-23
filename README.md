# Real-time-Collaborative-Markdown-Editor
This is a multi-user collaborative document editor — a command-line, slimmed-down Google Docs.

**Description**\n
I built a multi-user collaborative document editor — a command-line, slimmed-down Google Docs. The server stores the document and queues each client operation (insert, delete, bold, etc.), then broadcasts the results so everyone stays in sync. Documents are saved as plain text in a simplified Markdown-like format.

**Details**\n
 ·Designed and shipped a fully-functioning client-server architecture in pure C: the server
 spawns spawns one POSIX thread per client plus a broadcast thread, enabling dozens of
 users to edit the same document concurrently without blocking.
 \n
 ·Implemented low-latency inter-process communication with realtime signals for the initial
 handshake and bidirectional named FIFOs for the data stream, avoiding sockets and keeping
 the solution portable on standard Linux.
 \n
 ·Engineered an efficient, copy-on-write document model based on a linked-list of chunk
 nodes; inserts, deletes and formatting changes run in O(1)–O(n) without shifting large
 buffers.
 \n
 ·Built conflict-free operational semantics and per-version history: each command carries a
 target version; the server time-orders commands, resolves cursor shifts, then atomically
 increments the version before broadcasting, guaranteeing consistency across clients.
 \n
 ·Addedsmart Markdown features such as automatic ordered-list renumbering, block-level
 formatting detection, and cursor-aware newline / heading logic, all handled server-side.
 \n
 ·Enforced role-based access control (read vs write) via a roles.txt lookup and permission
 checks on every command, preventing unauthorised edits. server_helpers
 \n
 ·Instrumented comprehensive logging and debug tooling (DOC?, LOG?, PERM?) as well as
 graceful shutdown that persists the latest document to doc.md.
 \n
 ·Hard-ned memory-safe, race-free implementation: all shared structures are protected with
 mutexes; custom alloc/free paths eliminate leaks detected by sanitizers. server_helpers
 \n
 **Technologies & concepts used**\n
 ·C11/POSIX APIs: pthread, realtime signal(7), mkfifo, nanosleep, sigaction.
 ·Concurrent programming: per-client queues, mutex-guarded critical sections,
role-based authorisation, detailed error codes.
 ·Logging & observability: thread-safe in-memory log linked list with runtime
 inspection commands.
\n
 **How to use it?**\n
 How to Use (Quick 6 Steps)
Build

bash
Copy
Edit
make    # Produces ./server and ./client
Start the server

bash
Copy
Edit
./server doc.txt [--fifo <name> | --port <port> | other opts...]
Start a client

bash
Copy
Edit
./client <username> [matching server options...]
Enter edit commands, e.g.

text
Copy
Edit
INSERT <pos> "<text>"
DEL <start> <len>
BOLD <start> <len>
HELP | SAVE | QUIT ...
Stay in sync
The client periodically pulls (or the server pushes) new versions; your view refreshes so everyone sees the same state.

Exit

text
Copy
Edit
QUIT
or just close the client process (Ctrl+C).
 
