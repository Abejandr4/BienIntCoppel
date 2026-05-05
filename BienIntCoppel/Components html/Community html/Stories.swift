//
//  Stories.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import Foundation
import { Plus } from "lucide-react";

const stories = [
  { name: "Tu historia", isUser: true, img: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=80&h=80&fit=crop" },
  { name: "Ana R.", img: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&h=80&fit=crop" },
  { name: "Carlos M.", img: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&h=80&fit=crop" },
  { name: "María L.", img: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop" },
  { name: "José P.", img: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=80&h=80&fit=crop" },
  { name: "Laura G.", img: "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=80&h=80&fit=crop" },
];

export default function Stories() {
  return (
    <section className="px-5 mt-2" aria-label="Historias de la comunidad">
      <div className="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
        {stories.map((story, i) => (
          <button
            key={i}
            className="flex flex-col items-center gap-1 flex-shrink-0"
            aria-label={story.isUser ? "Agregar tu historia" : `Ver historia de ${story.name}`}
          >
            <div className={`relative w-16 h-16 rounded-full ${story.isUser ? "border-2 border-dashed border-muted-foreground/30" : "p-[2px] bg-gradient-to-br from-orange-400 to-emerald-400"}`}>
              <img
                src={story.img}
                alt=""
                className={`w-full h-full rounded-full object-cover ${!story.isUser ? "border-2 border-white" : ""}`}
              />
              {story.isUser && (
                <div className="absolute -bottom-0.5 -right-0.5 w-5 h-5 bg-primary rounded-full flex items-center justify-center border-2 border-white">
                  <Plus className="w-3 h-3 text-white" />
                </div>
              )}
            </div>
            <span className="text-[10px] font-body text-muted-foreground max-w-[60px] truncate">
              {story.name}
            </span>
          </button>
        ))}
      </div>
    </section>
  );
}
