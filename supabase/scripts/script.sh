#!/bin/bash
# Supabase - Open-Source Firebase Alternative Reference
# Powered by BytesAgain — https://bytesagain.com

set -euo pipefail

cmd_intro() {
cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              SUPABASE REFERENCE                             ║
║          Open-Source Firebase Alternative                    ║
╚══════════════════════════════════════════════════════════════╝

Supabase is an open-source Firebase alternative built on
PostgreSQL. It provides everything you need to build a full-stack
app: database, auth, storage, realtime, edge functions.

COMPONENTS:
  Database       PostgreSQL with pgvector, PostGIS
  Auth           Email, OAuth, Magic Link, SSO
  Storage        S3-compatible file storage
  Realtime       WebSocket subscriptions on DB changes
  Edge Functions Deno-based serverless functions
  AI/Vectors     pgvector for embeddings
  Studio         Web-based admin dashboard

SUPABASE vs FIREBASE vs APPWRITE:
  ┌──────────────┬──────────┬──────────┬──────────┐
  │ Feature      │ Supabase │ Firebase │ Appwrite │
  ├──────────────┼──────────┼──────────┼──────────┤
  │ Database     │ Postgres │ Firestore│ MariaDB  │
  │ Query        │ SQL      │ NoSQL    │ REST     │
  │ Self-host    │ Yes      │ No       │ Yes      │
  │ License      │ Apache2  │ Prop     │ BSD      │
  │ Realtime     │ PG CDC   │ Native   │ WebSocket│
  │ Auth         │ GoTrue   │ Firebase │ Built-in │
  │ Edge Funcs   │ Deno     │ Node.js  │ Multiple │
  │ Pricing      │ Generous │ Pay/use  │ Self-host│
  └──────────────┴──────────┴──────────┴──────────┘

FREE TIER:
  500 MB database, 1 GB storage, 2 GB bandwidth
  50K monthly active users, 500K Edge Function invocations
EOF
}

cmd_database() {
cat << 'EOF'
DATABASE & QUERIES
====================

JAVASCRIPT CLIENT:
  import { createClient } from '@supabase/supabase-js'
  const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

  // SELECT
  const { data, error } = await supabase
    .from('posts')
    .select('*, author:users(name, email)')
    .eq('published', true)
    .order('created_at', { ascending: false })
    .limit(20)

  // INSERT
  const { data, error } = await supabase
    .from('posts')
    .insert({ title: 'Hello', body: '...', user_id: '...' })
    .select()

  // UPDATE
  const { data } = await supabase
    .from('posts')
    .update({ title: 'Updated' })
    .eq('id', postId)
    .select()

  // DELETE
  await supabase.from('posts').delete().eq('id', postId)

  // UPSERT
  await supabase.from('profiles').upsert({
    id: userId, name: 'Alice', updated_at: new Date()
  })

FILTERS:
  .eq('column', value)       // =
  .neq('column', value)      // !=
  .gt('column', value)       // >
  .lt('column', value)       // <
  .gte / .lte                // >= / <=
  .like('name', '%alice%')   // LIKE
  .ilike('name', '%alice%')  // ILIKE (case-insensitive)
  .is('deleted_at', null)    // IS NULL
  .in('status', ['active', 'pending'])
  .contains('tags', ['python'])
  .textSearch('body', 'hello world')

RPC (call PostgreSQL functions):
  // SQL function
  CREATE FUNCTION get_top_users(limit_count int)
  RETURNS SETOF users AS $$
    SELECT * FROM users ORDER BY score DESC LIMIT limit_count;
  $$ LANGUAGE sql;

  // Call from client
  const { data } = await supabase.rpc('get_top_users', { limit_count: 10 })

ROW LEVEL SECURITY (RLS):
  -- Enable RLS
  ALTER TABLE posts ENABLE ROW LEVEL SECURITY;

  -- Users can only read published posts
  CREATE POLICY "Public posts" ON posts
    FOR SELECT USING (published = true);

  -- Users can only edit their own posts
  CREATE POLICY "Own posts" ON posts
    FOR ALL USING (auth.uid() = user_id);

  -- Service role bypasses RLS (for admin operations)
EOF
}

cmd_features() {
cat << 'EOF'
AUTH, STORAGE & REALTIME
==========================

AUTH:
  // Email + password
  const { data, error } = await supabase.auth.signUp({
    email: 'alice@example.com',
    password: 'strong-password'
  })

  // Sign in
  await supabase.auth.signInWithPassword({ email, password })

  // OAuth
  await supabase.auth.signInWithOAuth({ provider: 'google' })
  await supabase.auth.signInWithOAuth({ provider: 'github' })

  // Magic link
  await supabase.auth.signInWithOtp({ email: 'alice@example.com' })

  // Get current user
  const { data: { user } } = await supabase.auth.getUser()

  // Sign out
  await supabase.auth.signOut()

  // Auth state listener
  supabase.auth.onAuthStateChange((event, session) => {
    console.log(event, session)
  })

STORAGE:
  // Upload
  const { data, error } = await supabase.storage
    .from('avatars')
    .upload('public/avatar.png', file, {
      contentType: 'image/png',
      upsert: true
    })

  // Download
  const { data } = await supabase.storage
    .from('avatars')
    .download('public/avatar.png')

  // Public URL
  const { data } = supabase.storage
    .from('avatars')
    .getPublicUrl('public/avatar.png')

  // Signed URL (temporary)
  const { data } = await supabase.storage
    .from('private')
    .createSignedUrl('document.pdf', 3600)

  // List files
  const { data } = await supabase.storage
    .from('avatars')
    .list('public', { limit: 100 })

REALTIME (subscribe to DB changes):
  const channel = supabase
    .channel('posts-changes')
    .on('postgres_changes',
      { event: '*', schema: 'public', table: 'posts' },
      (payload) => {
        console.log('Change:', payload)
      }
    )
    .subscribe()

  // Specific events
  .on('postgres_changes', { event: 'INSERT', ... })
  .on('postgres_changes', { event: 'UPDATE', ... })
  .on('postgres_changes', { event: 'DELETE', ... })

  // Filter
  .on('postgres_changes', {
    event: 'INSERT',
    schema: 'public',
    table: 'messages',
    filter: 'room_id=eq.123'
  })

  // Broadcast (custom events, no DB)
  channel.send({ type: 'broadcast', event: 'cursor', payload: { x, y } })

  // Presence (online status)
  channel.track({ user_id: '123', online_at: new Date() })

EDGE FUNCTIONS (Deno):
  supabase functions new my-function
  supabase functions serve my-function
  supabase functions deploy my-function

  // index.ts
  Deno.serve(async (req) => {
    const { name } = await req.json()
    return new Response(JSON.stringify({ message: `Hello ${name}` }))
  })

Powered by BytesAgain — https://bytesagain.com
Contact: hello@bytesagain.com
EOF
}

show_help() {
cat << 'EOF'
Supabase - Open-Source Firebase Alternative Reference

Commands:
  intro      Overview, comparison
  database   Queries, RPC, Row Level Security
  features   Auth, Storage, Realtime, Edge Functions

Usage: $0 <command>
EOF
}

case "${1:-help}" in
  intro)    cmd_intro ;;
  database) cmd_database ;;
  features) cmd_features ;;
  help|*)   show_help ;;
esac
