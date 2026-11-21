create extension if not exists pgcrypto;
create table if not exists public.chats (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null default 'Neuer Chat',
 source text not null default 'website' check(source in ('website','claude-import')),
 synced boolean not null default true,
 archived boolean not null default false,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.messages (
 id uuid primary key default gen_random_uuid(),
 chat_id uuid not null references public.chats(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 role text not null check(role in ('user','assistant','system')),
 content text not null,
 created_at timestamptz not null default now()
);
create table if not exists public.handoffs (
 id uuid primary key default gen_random_uuid(),
 chat_id uuid not null references public.chats(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 message_id uuid references public.messages(id) on delete set null,
 prompt text not null,
 status text not null default 'pending' check(status in ('pending','approved','sent','answered','rejected')),
 response text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.devices (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 name text not null default 'Handy',
 last_seen timestamptz not null default now(),
 created_at timestamptz not null default now(),
 unique(user_id,name)
);
create index if not exists chats_user_updated on public.chats(user_id,updated_at desc);
create index if not exists messages_chat_created on public.messages(chat_id,created_at);
create index if not exists handoffs_user_created on public.handoffs(user_id,created_at desc);
alter table public.chats enable row level security;
alter table public.messages enable row level security;
alter table public.handoffs enable row level security;
alter table public.devices enable row level security;
create policy "own chats" on public.chats for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own messages" on public.messages for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own handoffs" on public.handoffs for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
create policy "own devices" on public.devices for all using(auth.uid()=user_id) with check(auth.uid()=user_id);
do $$ begin
 alter publication supabase_realtime add table public.handoffs;
exception when duplicate_object then null;
when undefined_object then null;
end $$;