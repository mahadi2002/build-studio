# Audio and WebRTC
tier: 2 | sources: W3C WebRTC and Media Capture specs, RFC 8445 (ICE) and RFC 8656 (TURN), MDN Web Audio API | updated: 2026-11-26

## Triggers
- Live calls, screen share, voice or video chat, live audio, in-browser recording, audio processing.
- Words like peer connection, TURN, STUN, SFU, latency, echo, jitter, codec.
- Not for: playing a stored file (a plain audio tag). Not for on-demand video streaming (HLS or a CDN).
## Responsibilities
- Architecture: topology (peer to peer, SFU), signaling channel, TURN plan, recording plan.
- Plan: expected call size and a latency target. Verify on two real networks.
## Role-specific rules
1. Choose topology by size. Two people: peer to peer. A few: mesh is possible but heavy. More: use an SFU (exact cutoff: uncertain).
2. You build the signaling (WebSocket or similar). It carries only offers, answers and ICE candidates.
3. Configure STUN and a TURN fallback. Some networks (strict NAT, mobile data, campus) block direct paths. Test behind one.
4. TURN relays real media and costs bandwidth. A paid or hosted TURN is G3. Never put long-lived TURN credentials in client code; issue short-lived ones from the server.
5. Capture with echo cancellation, noise suppression and auto gain on. Use headphones in tests.
6. Ask for mic and camera only on a user action, show a clear live indicator, and handle denial.
7. Recording needs consent from every participant, a visible indicator, a stated retention time and access-controlled storage. Check local law (uncertain). Real recordings are G3.
8. Make quality visible: read `getStats()` for round trip time, packet loss and jitter, and log them.
9. Adapt to bad networks: let resolution and bitrate fall. Audio quality matters more than video.
10. Authenticate signaling. Anyone who can join a room can listen.
## Default tool options
- Small peer to peer apps: plain WebRTC, PeerJS, simple-peer.
- SFU, open source and self-hosted: LiveKit, mediasoup, Janus. Hosted free tiers exist; the account is G3.
- TURN: coturn on your own VPS (open source), or a provider free tier.
- Browser audio: Web Audio API with AudioWorklet; Tone.js for music.
## Checklist
- [ ] Call works across two networks, one behind strict NAT or on mobile data
- [ ] TURN path forced and tested
- [ ] Permission denied and device unplugged handled
- [ ] Consent flow and indicator present if recording
## Common mistakes
- Works on one Wi-Fi, fails in production. Test with TURN forced.
- A hard-coded TURN secret in the page. Mint short-lived credentials.
- Recording silently. Show consent and an indicator.
## Definition of done
- A two-network call log with `getStats()` numbers (rtt, loss, jitter) and a screenshot.
- TURN-forced test passes. Consent text and retention rule documented if recording exists.
## Per-stack notes
- Browser: `getUserMedia`, `RTCPeerConnection`; Safari may need a user gesture before audio starts.
