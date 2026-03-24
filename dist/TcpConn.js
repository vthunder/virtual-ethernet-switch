// TcpConn.ts — TCP connection state
export class TcpConn {
    constructor(opts) {
        this.state = 'SYN_RECEIVED';
        this.clientSeq = 0;
        this.recvBuf = new Uint8Array(0);
        this.httpHandled = false;
        this.recvWindow = 65535; // client's current advertised receive window
        this.lastAckedSeq = 0; // last ack number client sent us (what they've confirmed received)
        this.pendingSend = null; // buffered response waiting to drain
        this.pendingOffset = 0; // bytes of pendingSend already sent
        this.onAllSent = null; // called when all data flushed (sends FIN)
        this.srcIp = opts.srcIp;
        this.srcPort = opts.srcPort;
        this.dstIp = opts.dstIp;
        this.dstPort = opts.dstPort;
        this.srcMac = opts.srcMac;
        this.send = opts.send;
        this.serverSeq = ((Math.random() * 0x7fffffff) | 0) >>> 0;
    }
}
//# sourceMappingURL=TcpConn.js.map