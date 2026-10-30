-- Run this once in Supabase: SQL Editor > New query > paste > Run.
create table projects(id uuid primary key default gen_random_uuid(),title text not null,category text not null default 'Branding',description text,image_url text,sort int default 0,created_at timestamptz default now());
create table packages(id uuid primary key default gen_random_uuid(),name text not null,price text,features text,featured boolean default false,sort int default 0,created_at timestamptz default now());
create table settings(key text primary key,value text);
create table orders(id uuid primary key default gen_random_uuid(),created_at timestamptz default now(),name text,contact text,service text,payment text,budget text,deadline text,details text,status text default 'new');
alter table projects enable row level security;
alter table packages enable row level security;
alter table settings enable row level security;
alter table orders enable row level security;
-- Only this email can change anything (even if someone else signs up).
create function is_admin() returns boolean language sql stable as $$ select coalesce(auth.jwt()->>'email','')='abhicreations128@gmail.com' $$;
create policy "public read" on projects for select using (true);
create policy "admin write" on projects for all using (is_admin()) with check (is_admin());
create policy "public read" on packages for select using (true);
create policy "admin write" on packages for all using (is_admin()) with check (is_admin());
create policy "public read" on settings for select using (true);
create policy "admin write" on settings for all using (is_admin()) with check (is_admin());
create policy "customers can send orders" on orders for insert with check (true);
create policy "admin orders" on orders for all using (is_admin()) with check (is_admin());
-- Photo storage
insert into storage.buckets(id,name,public) values('projects','projects',true) on conflict do nothing;
create policy "admin photos" on storage.objects for all to authenticated using (bucket_id='projects' and is_admin()) with check (bucket_id='projects' and is_admin());
-- Starting content (edit later in the admin panel)
insert into packages(name,price,features,featured,sort) values
('Logo design','From Rs. X,XXX',E'3 concept directions\n2 rounds of revisions\nPNG, SVG and PDF files',false,1),
('Brand identity','From Rs. XX,XXX',E'Logo and colour palette\nTypography and brand guide PDF\nSocial media profile kit',true,2),
('Social media pack','From Rs. X,XXX',E'10 post designs\nStory templates\nEditable source files',false,3);
insert into settings(key,value) values('bank','Your bank and branch'),('account_name','A W E H Abhishek De Silva'),('account_number','0000 0000 0000'),('wallet','07X XXX XXXX'),('terms','50% advance to start, the balance before final files are delivered.');
