# 共通鍵暗号の分類
- ストリーム暗号
    - 1ビット,1バイトなどの最小単位での暗号化
- ブロック暗号
    - 固定のビット長・バイト長でのブロックに分割して暗号化



- 推奨・推奨候補・運用監視の３分類

# 共通鍵暗号の例としてのwifi
規格(古い順)
- WEP
    - 暗号化: RC4
        - ストリーム暗号
        - 現在は非推奨
- WPA
    - 暗号化: TKIP
        - RC4のラップ
        - 現在は非推奨
- WPA2
    - 暗号化: CCMP (AES-CCMP)
        - AESがブロック暗号なので、それをストリーム的に扱えるようにしたのがCCMPらしい
        - AESは現在も推奨
- WPA3
    - 暗号化: CCMP (AES-CCMP) or GCMP-256
        - なんかGCMP-256の方が強くて早いらしい

- 認証に関してはまた別。


# ChaCha20-Poly1305の実装性能調査
https://www.cryptrec.go.jp/exreport/cryptrec-ex-2702-2017.pdf

# PS3 ECDSA
https://qiita.com/tnakagawa/items/35c5f02d6a47ec773eb3

# Dual_EC_DRBG
https://www.cryptrec.go.jp/topics/cryptrec-er-0001-2013.html
https://techmedia-think.hatenablog.com/entry/2020/10/14/235117

# 離散対数
https://ipsj.ixsq.nii.ac.jp/record/4333/files/IPSJ-MGN340207.pdf

# シュノア署名
https://qiita.com/tnakagawa/items/a68606f005630cd09415
## BIP340
https://github.com/bitcoin/bips/blob/master/bip-0340.mediawiki


# ssh
## handshake
https://goteleport.com/blog/ssh-handshake-explained/
