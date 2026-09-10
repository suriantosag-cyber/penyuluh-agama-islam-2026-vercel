import {cookies} from "next/headers";import crypto from "crypto";
const cookieName="sidrap_admin";
function token(){const p=process.env.ADMIN_PASSWORD||"";const s=process.env.ADMIN_SESSION_SECRET||"fallback-secret";return crypto.createHash("sha256").update(p+"::"+s).digest("hex")}
export async function isAdmin(){const c=await cookies();return c.get(cookieName)?.value===token()}
export async function setAdmin(){const c=await cookies();c.set(cookieName,token(),{httpOnly:true,sameSite:"lax",secure:process.env.NODE_ENV==="production",path:"/",maxAge:60*60*8})}
export async function clearAdmin(){const c=await cookies();c.set(cookieName,"",{httpOnly:true,sameSite:"lax",secure:process.env.NODE_ENV==="production",path:"/",maxAge:0})}
