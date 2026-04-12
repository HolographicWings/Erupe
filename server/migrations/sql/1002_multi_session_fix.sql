/* disable logging on the sign_session table */
ALTER TABLE public.sign_sessions SET UNLOGGED;

/* add a created_ad column in the sign_session table */
ALTER TABLE public.sign_sessions
    ADD COLUMN created_at timestamptz NOT NULL DEFAULT now();

/* creating index on the char_id column to avoid characters to be online twice */
CREATE UNIQUE INDEX sign_sessions_char_uq
    ON public.sign_sessions (char_id);

/* creating index on the user_id column to avoid users to be logged twice */
CREATE UNIQUE INDEX sign_sessions_user_active_uq
    ON public.sign_sessions (user_id)
    WHERE user_id IS NOT NULL
      AND char_id IS NOT NULL;

/* creating index on the created_at column */	
CREATE INDEX sign_sessions_stale_launcher_idx
    ON public.sign_sessions (created_at)
    WHERE char_id IS NULL;