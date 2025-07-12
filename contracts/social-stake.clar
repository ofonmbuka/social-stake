
;; SocialStake - Bitcoin-Native Social Graph Protocol
;;
;; Summary:
;; A revolutionary decentralized social networking protocol that transforms 
;; digital relationships into verifiable, stake-backed connections on Bitcoin's 
;; secure foundation through Stacks smart contracts.
;;
;; Description:
;; SocialStake pioneers the next generation of social networking by creating 
;; an immutable, trustless social graph where every interaction carries real 
;; economic weight. Users stake STX to establish credibility, follow trusted 
;; peers, publish content, and build reputation scores that reflect genuine 
;; community value. Unlike traditional social media, every action is transparent, 
;; verifiable, and contributes to a decentralized trust economy. The protocol 
;; enables stake-weighted influence, peer endorsements, and content amplification 
;; through economic incentives, creating a sustainable social ecosystem where 
;; reputation is earned, not gamed.
;;
;; Core Innovation:
;; - Stake-to-earn social reputation system
;; - Economic incentives for quality content and genuine connections
;; - Transparent, on-chain social graph with Bitcoin-level security
;; - Decentralized influence scoring based on community validation
;; - Cross-platform social identity with portable reputation

;; PROTOCOL CONSTANTS

(define-constant CONTRACT_OWNER tx-sender)

;; Error codes
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_PROFILE_EXISTS (err u101))
(define-constant ERR_PROFILE_NOT_FOUND (err u102))
(define-constant ERR_INSUFFICIENT_FUNDS (err u103))
(define-constant ERR_INVALID_AMOUNT (err u104))
(define-constant ERR_ALREADY_FOLLOWING (err u105))
(define-constant ERR_NOT_FOLLOWING (err u106))
(define-constant ERR_SELF_FOLLOW (err u107))
(define-constant ERR_ALREADY_ENDORSED (err u108))
(define-constant ERR_POST_NOT_FOUND (err u109))
(define-constant ERR_INVALID_POST_ID (err u110))

;; Minimum stake requirements (in microSTX)
(define-constant MIN_PROFILE_STAKE u1000000)    ;; 1 STX - Identity verification
(define-constant MIN_POST_BOOST u100000)        ;; 0.1 STX - Content amplification
(define-constant MIN_ENDORSEMENT_STAKE u500000) ;; 0.5 STX - Peer validation

;; PROTOCOL STATE VARIABLES

(define-data-var next-profile-id uint u1)
(define-data-var next-post-id uint u1)
(define-data-var protocol-fee-rate uint u100) ;; 1% = 100 basis points

;; CORE DATA STRUCTURES

;; User Profile Registry
(define-map profiles
  { profile-id: uint }
  {
    owner: principal,
    username: (string-ascii 50),
    bio: (string-utf8 280),
    avatar-url: (string-ascii 200),
    created-at: uint,
    staked-amount: uint,
    reputation-score: uint,
    follower-count: uint,
    following-count: uint,
    post-count: uint,
    total-endorsements: uint,
    is-active: bool
  }
)

;; Username Resolution System
(define-map username-to-profile (string-ascii 50) uint)

;; Principal-to-Profile Mapping
(define-map principal-to-profile principal uint)

;; Social Graph Connections
(define-map following
  { follower: uint, following: uint }
  { followed-at: uint, is-active: bool }
)

;; Content Publication System
(define-map posts
  { post-id: uint }
  {
    author: uint,
    content: (string-utf8 500),
    created-at: uint,
    boosted-amount: uint,
    endorsement-count: uint,
    is-active: bool
  }
)

;; Content Endorsement Tracking
(define-map post-endorsements
  { post-id: uint, endorser: uint }
  { endorsed-at: uint, stake-amount: uint }
)

;; Peer Reputation System
(define-map profile-endorsements
  { endorser: uint, endorsed: uint }
  { endorsed-at: uint, stake-amount: uint, message: (string-utf8 140) }
)