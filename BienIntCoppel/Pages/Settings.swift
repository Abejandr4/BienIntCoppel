//
//  Settings.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { useEffect, useState } from "react";
import { base44 } from "@/api/base44Client";
import { User, Bell, Shield, Moon, LogOut, ChevronRight } from "lucide-react";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Switch } from "@/components/ui/switch";

const settingsGroups = [
  {
    items: [
      { icon: Bell, label: "Notificaciones", hasToggle: true },
      { icon: Shield, label: "Privacidad", hasArrow: true },
      { icon: Moon, label: "Modo oscuro", hasToggle: true },
    ],
  },
];

export default function Settings() {
  const [user, setUser] = useState(null);

  useEffect(() => {
    base44.auth.me().then(setUser).catch(() => {});
  }, []);

  const name = user?.full_name || "Usuario";
  const email = user?.email || "";
  const initials = name.split(" ").map(n => n[0]).join("").slice(0, 2).toUpperCase();

  const handleLogout = () => {
    base44.auth.logout("/");
  };

  return (
    <div className="min-h-screen">
      {/* Header */}
      <div className="relative overflow-hidden rounded-b-3xl">
        <div className="absolute inset-0 bg-gradient-to-br from-orange-400 via-orange-300 to-emerald-300 opacity-90" />
        <div className="relative px-5 pt-12 pb-8 flex flex-col items-center">
          <Avatar className="w-20 h-20 border-3 border-white/60 shadow-lg mb-3">
            <AvatarFallback className="bg-white/30 text-white font-heading font-bold text-2xl">
              {initials}
            </AvatarFallback>
          </Avatar>
          <h1 className="text-xl font-heading font-bold text-white">{name}</h1>
          <p className="text-xs font-body text-white/80 mt-0.5">{email}</p>
        </div>
      </div>

      {/* Settings list */}
      <div className="px-5 mt-6 space-y-2">
        {settingsGroups.map((group, gi) => (
          <div key={gi} className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden">
            {group.items.map((item, ii) => (
              <div
                key={ii}
                className={`flex items-center gap-3 px-4 py-3.5 ${ii < group.items.length - 1 ? "border-b border-border/50" : ""}`}
              >
                <div className="w-9 h-9 rounded-xl bg-muted flex items-center justify-center">
                  <item.icon className="w-4 h-4 text-muted-foreground" aria-hidden="true" />
                </div>
                <span className="flex-1 text-sm font-body font-medium text-foreground">{item.label}</span>
                {item.hasToggle && <Switch />}
                {item.hasArrow && <ChevronRight className="w-4 h-4 text-muted-foreground" />}
              </div>
            ))}
          </div>
        ))}

        {/* Logout */}
        <button
          onClick={handleLogout}
          className="w-full bg-card rounded-2xl border border-border shadow-sm flex items-center gap-3 px-4 py-3.5 hover:bg-destructive/5 transition-colors"
        >
          <div className="w-9 h-9 rounded-xl bg-destructive/10 flex items-center justify-center">
            <LogOut className="w-4 h-4 text-destructive" aria-hidden="true" />
          </div>
          <span className="text-sm font-body font-medium text-destructive">Cerrar Sesión</span>
        </button>
      </div>

      <div className="text-center py-8">
        <p className="text-[10px] font-body text-muted-foreground">Coppel Bienestar v1.0</p>
      </div>
    </div>
  );
}
