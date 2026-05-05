//
//  UserHeader.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { useEffect, useState } from "react";
import { base44 } from "@/api/base44Client";
import { Bell } from "lucide-react";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";

export default function UserHeader() {
  const [user, setUser] = useState(null);

  useEffect(() => {
    base44.auth.me().then(setUser).catch(() => {});
  }, []);

  const name = user?.full_name?.split(" ")[0] || "Usuario";
  const initials = user?.full_name
    ? user.full_name.split(" ").map(n => n[0]).join("").slice(0, 2).toUpperCase()
    : "U";

  return (
    <div className="relative overflow-hidden rounded-b-3xl">
      {/* Gradient background */}
      <div className="absolute inset-0 bg-gradient-to-br from-orange-400 via-orange-300 to-emerald-300 opacity-90" />
      <div className="relative px-5 pt-12 pb-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <Avatar className="w-12 h-12 border-2 border-white/60 shadow-lg">
              <AvatarFallback className="bg-white/30 text-white font-heading font-bold text-lg">
                {initials}
              </AvatarFallback>
            </Avatar>
            <div>
              <p className="text-white/80 text-xs font-body font-medium">Bienvenido de vuelta</p>
              <h1 className="text-white text-xl font-heading font-bold">¡Hola {name}!</h1>
            </div>
          </div>
          <button
            className="w-10 h-10 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center transition-transform hover:scale-105"
            aria-label="Notificaciones"
          >
            <Bell className="w-5 h-5 text-white" />
          </button>
        </div>
      </div>
    </div>
  );
}
