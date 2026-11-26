# Network software
tier: 2 | sources: IETF RFCs (RFC 9293 TCP, RFC 9000 QUIC), Beej's Guide to Network Programming, WireGuard whitepaper | updated: 2026-11-26

## Triggers
- Custom protocols, sockets, proxies, reverse proxies, VPN or tunnel tools, packet parsing, load balancers, DNS tools.
- Not for: ordinary HTTP APIs (backend role) or capturing traffic on networks you do not own (SKILL.md 6.4 offensive testing).

## Responsibilities
- Architecture: protocol spec (framing, versions, errors, timeouts), threat model, trust boundaries.
- Verify: tests on loopback and in containers, with injected loss and delay. Handoff: protocol doc and ports list.

## Role-specific rules
1. Write the wire format first: field sizes, byte order, max lengths, version byte, and what a bad packet does.
2. Treat every byte from the network as hostile: length-check before reading, cap sizes, never trust a length field.
3. TCP is a byte stream. Frame messages yourself (length prefix or delimiter) and handle partial reads and writes.
4. Set timeouts on connect, read, write and idle. Bound connections per client and total.
5. Use TLS 1.2 or later (1.3 preferred) or a vetted tunnel like WireGuard. Never invent your own crypto or handshake.
6. Proxies: strip hop-by-hop headers, block private and metadata addresses as targets (SSRF), and do not become an open relay.
7. Test with loss, reordering, duplicates, slow peers and half-closed connections, not only the clean path.
8. Binding to a port, opening a firewall or running a tunnel on a public host creates exposure; confirm it as G3 if it touches real users.

## Default tool options
- Test and inspect: Wireshark, `tcpdump`, `nmap` (own hosts only), `netcat`, `iperf3`; `tc netem` or Toxiproxy for loss and delay.
- Building blocks: language standard library sockets first; Tokio or Go `net` for scale; libuv or Boost.Asio in C/C++.
- Tunnels and VPN: WireGuard; Cloudflare Tunnel for exposing a dev service free (account creation is G3).

## Checklist
- [ ] Spec, fuzz test on the parser and a malformed-packet test exist
- [ ] Timeouts and connection caps are set and tested with a slow client

## Common mistakes
- Assuming one `read` equals one message → buffer and frame.
- No idle timeout → slow clients exhaust file descriptors. Missing endianness conversion → use explicit byte-order calls.

## Definition of done
Tests pass on loopback with injected faults, the fuzz run is clean, and the protocol doc matches the code.

## Per-stack notes
- Python: `asyncio` streams and `struct`; `scapy` only against lab hosts you own.
- Go: `net.Conn` deadlines on each call; Rust: `tokio` with `tokio-util` codecs for framing. C/C++: use `poll` or `epoll`, check every return value.
