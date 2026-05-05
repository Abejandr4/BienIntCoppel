//
//  Community.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { Plus } from "lucide-react";
import Stories from "@/components/community/Stories";
import PostFeed from "@/components/community/PostFeed";

export default function Community() {
  return (
    <div className="min-h-screen">
      {/* Header */}
      <div className="relative overflow-hidden rounded-b-3xl">
        <div className="absolute inset-0 bg-gradient-to-br from-orange-400 via-amber-300 to-emerald-300 opacity-90" />
        <div className="relative px-5 pt-12 pb-6">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-xl font-heading font-bold text-white">Comunidad</h1>
              <p className="text-xs font-body text-white/80">Comparte tus logros de bienestar</p>
            </div>
            <button
              className="w-10 h-10 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center hover:bg-white/30 transition-colors"
              aria-label="Crear nueva publicación"
            >
              <Plus className="w-5 h-5 text-white" />
            </button>
          </div>
        </div>
      </div>

      <Stories />
      <PostFeed />
    </div>
  );
}
