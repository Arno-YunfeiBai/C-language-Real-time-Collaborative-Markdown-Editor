# C language Real-time-Collaborative-Markdown-Editor
This is a multi-user collaborative document editor — a command-line, slimmed-down Google Docs.

## 1. Description

I built a multi-user collaborative document editor — a command-line, slimmed-down Google Docs. The server stores the document and queues each client operation (insert, delete, bold, etc.), then broadcasts the results so everyone stays in sync. Documents are saved as plain text in a simplified Markdown-like format.

## 2. Features
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
 
 ## 3. Technologies & concepts used
 
 ·C11/POSIX APIs: pthread, realtime signal(7), mkfifo, nanosleep, sigaction.
 ·Concurrent programming: per-client queues, mutex-guarded critical sections,
role-based authorisation, detailed error codes.
 ·Logging & observability: thread-safe in-memory log linked list with runtime
 inspection commands.

## 4. Project structure
```
.
├── Makefile
├── roles.txt
├── src/
│   ├── server.c
│   ├── client.c
│   ├── server_helpers.c
│   ├── client_helpers.c
│   ├── markdown.c
│   └── log.c
├── libs/
│   ├── document.h
│   ├── markdown.h
│   ├── server_helpers.h
│   ├── client_helpers.h
│   └── log.h
└── README.md
```

 ## 5. How to use it?

 How to Use (Quick 6 Steps)
1. Build

`make    # Produces ./server and ./client`

2. Start the server

`./server doc.txt <TIME_INTERVAL>`
Then you the server pid will be shown on the screen.

3. Start a client

Use the pid just shown and enter:
`./client <server_pid> <username>`

4. Start and connect more clients(optional)

5. Enter edit commands in the client side, e.g.

`INSERT <pos> <text>
DEL <start> <len>
BOLD <start> <END>
LOG?
DOC?`

6. Stay in sync
The client periodically pulls (or the server pushes) new versions; your view refreshes so everyone sees the same state.

7. Exit

With command `DISCONNECT` to disconnect client with server.
After all clients are disconnected, enter `QUIT` in Server side to quit the server.
or just close the client process (Ctrl+C).

## 6. COMMANDS

### Client side:
**INSERT** `<pos>` `<content>`
Inserts the given text at the specified cursor position (no newlines allowed).

**DEL** `<pos>` `<del_len>`
Deletes the specified number of characters starting at the given position.

**NEWLINE** `<pos>`
Inserts a newline character at the specified position.

**HEADING** `<level>` `<pos>`
Inserts a heading of the given level (1–3) at the specified position.

**BOLD** `<pos_start>` `<pos_end>`
Applies bold formatting to the text between the specified positions.

**ITALIC** `<pos_start>` `<pos_end>`
Applies italic formatting to the text between the specified positions.

**BLOCKQUOTE** `<pos>`
Inserts blockquote formatting at the specified position.

**ORDERED_LIST** `<pos>`
Inserts an ordered list item at the specified position and renumbers existing items.

**UNORDERED_LIST** `<pos>`
Inserts an unordered list item at the specified position.

**CODE** `<pos_start>` `<pos_end>`
Applies inline code formatting to the text between the specified positions.

**HORIZONTAL_RULE** `<pos>`
Inserts a horizontal rule followed by a newline at the specified position.

**LINK** `<pos_start>` `<pos_end>` `<link>`
Converts the text between positions into a Markdown hyperlink [text](link).

**DISCONNECT**
Disconnects the client and cleans up the associated FIFOs.

**DOC?**
Prints the entire current document to the server terminal.

**LOG?**
Outputs the log of all executed commands, grouped by version.

**PERM?**
Requests and displays the client’s role/permission (read or write).

### Server side:

**DOC?**
Prints the entire current document to the server terminal.

**LOG?**
Outputs the log of all executed commands, grouped by version.

**QUIT**
Shuts down the server if no clients are connected, otherwise rejects with a message.

 ## 7. License
MIT – do anything, but give credit.

---

### 8. Author

**Yunfei Bai* – Advanced Computing student @ The University of Sydney  
*Solo development, April – May 2024*

