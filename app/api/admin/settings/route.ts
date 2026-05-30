export const dynamic = "force-dynamic";
export const runtime = "nodejs";
import { NextResponse } from "next/server";
import { getSession, canEdit } from "../../../../lib/auth";
import { supabaseAdmin } from "../../../../lib/supabase";

export async function GET() {
  const session = await getSession();
  if (!session) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  const { data } = await supabaseAdmin.from("settings").select("*").eq("id", 1).single();
  return NextResponse.json(data);
}

export async function PUT(req: Request) {
  const session = await getSession();
  if (!canEdit(session?.role)) return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  const body = await req.json();
  const { data, error } = await supabaseAdmin.from("settings").update(body).eq("id", 1).select().single();
  if (error) return NextResponse.json({ error: error.message }, { status: 400 });
  return NextResponse.json(data);
}
