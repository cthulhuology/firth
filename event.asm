;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; event.asm
; © 2013 David J Goehrig <dave@dloh.org>
;
; only doing kevent64 for now
;
; struct kevent64_s {
;            uint64_t        ident;          /* identifier for this event */
;            int16_t         filter;         /* filter for event */
;            uint16_t        flags;          /* general flags */
;            uint32_t        fflags;         /* filter-specific flags */
;            int64_t         data;           /* filter-specific data */
;            uint64_t        udata;          /* opaque user data identifier */
;            uint64_t        ext[2];         /* filter-specific extensions */
;    };

