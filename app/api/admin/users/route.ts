import { NextResponse } from "next/server";
import bcrypt from "bcryptjs";
import { getSession, canManageUsers } from "../../../../lib/auth";
import { supabaseAdmin } from "../../../../lib/supabase";

export async function GET() {
  const session = await getSession();
  if (!canManageUsers(session?.role)) return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  const { data } = await supabaseAdmin.from("app_users").select("id, username, role, is_active, created_at").order("created_at");
  return NextResponse.json(data || []);
}

export async function POST(req: Request) {
  const session = await getSession();
  if (!canManageUsers(session?.role)) return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  const { username, password, role } = await req.json();
  const password_hash = await bcrypt.hash(password, 10);
  const { data, error } = await supabaseAdmin.from("app_users").insert({ username, password_hash, role, is_active: true }).select("id, username, role, is_active").single();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json(data);
}

export async function PUT(req: Request) {
  const session = await getSession();
  if (!canManageUsers(session?.role)) return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  const { id, username, password, role, is_active } = await req.json();
  const updates: any = { username, role, is_active };
  if (password) updates.password_hash = await bcrypt.hash(password, 10);
  const { data, error } = await supabaseAdmin.from("app_users").update(updates).eq("id", id).select("id, username, role, is_active").single();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json(data);
}
