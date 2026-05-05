//
//  PostFeed.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { useState } from "react";
import { Heart, MessageCircle, Share2 } from "lucide-react";
import { motion } from "framer-motion";

const posts = [
  {
    id: 1,
    user: "Ana Ramírez",
    avatar: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=80&h=80&fit=crop",
    time: "Hace 2 horas",
    content: "¡Terminé mi primera sesión de meditación guiada! Me siento mucho más tranquila. 🧘‍♀️",
    tag: "Meta Mental Cumplida",
    tagColor: "bg-emerald-100 text-emerald-700",
    likes: 24,
    comments: 5,
    image: "https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400&h=250&fit=crop",
  },
  {
    id: 2,
    user: "Carlos Mendoza",
    avatar: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&h=80&fit=crop",
    time: "Hace 5 horas",
    content: "30 minutos de caminata durante el almuerzo. ¡Pequeños pasos hacen la diferencia! 💪",
    tag: "Entrenamiento Físico",
    tagColor: "bg-orange-100 text-orange-700",
    likes: 18,
    comments: 3,
  },
  {
    id: 3,
    user: "María López",
    avatar: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=80&h=80&fit=crop",
    time: "Hace 1 día",
    content: "¡Logré ahorrar el 10% de mi quincena este mes! La planificación financiera funciona. 📊",
    tag: "Logro Financiero",
    tagColor: "bg-amber-100 text-amber-700",
    likes: 32,
    comments: 8,
  },
  {
    id: 4,
    user: "José Pérez",
    avatar: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=80&h=80&fit=crop",
    time: "Hace 2 días",
    content: "Organizamos un torneo de futbol entre tiendas. ¡La mejor forma de hacer equipo! ⚽",
    tag: "Evento Social",
    tagColor: "bg-sky-100 text-sky-700",
    likes: 45,
    comments: 12,
  },
];

export default function PostFeed() {
  const [likedPosts, setLikedPosts] = useState({});

  const toggleLike = (id) => {
    setLikedPosts(prev => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <section className="px-5 mt-4 space-y-4 pb-4" aria-label="Feed de la comunidad">
      {posts.map((post, i) => (
        <motion.article
          key={post.id}
          initial={{ opacity: 0, y: 16 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: i * 0.08, duration: 0.35 }}
          className="bg-card rounded-2xl border border-border shadow-sm overflow-hidden"
        >
          {/* Header */}
          <div className="p-4 pb-2 flex items-center gap-3">
            <img
              src={post.avatar}
              alt={`Foto de perfil de ${post.user}`}
              className="w-9 h-9 rounded-full object-cover"
            />
            <div className="flex-1 min-w-0">
              <p className="text-sm font-heading font-semibold text-foreground">{post.user}</p>
              <p className="text-[10px] font-body text-muted-foreground">{post.time}</p>
            </div>
            <span className={`text-[10px] font-body font-medium px-2.5 py-1 rounded-full ${post.tagColor}`}>
              {post.tag}
            </span>
          </div>

          {/* Content */}
          <div className="px-4 pb-3">
            <p className="text-sm font-body text-foreground leading-relaxed">{post.content}</p>
          </div>

          {/* Image */}
          {post.image && (
            <img src={post.image} alt="" className="w-full h-44 object-cover" />
          )}

          {/* Actions */}
          <div className="px-4 py-3 flex items-center gap-6 border-t border-border/50">
            <button
              onClick={() => toggleLike(post.id)}
              className="flex items-center gap-1.5 text-xs font-body text-muted-foreground hover:text-red-500 transition-colors"
              aria-label={likedPosts[post.id] ? "Quitar me gusta" : "Dar me gusta"}
            >
              <Heart
                className={`w-4 h-4 transition-all ${likedPosts[post.id] ? "fill-red-500 text-red-500 scale-110" : ""}`}
              />
              {post.likes + (likedPosts[post.id] ? 1 : 0)}
            </button>
            <button
              className="flex items-center gap-1.5 text-xs font-body text-muted-foreground hover:text-primary transition-colors"
              aria-label="Comentar"
            >
              <MessageCircle className="w-4 h-4" />
              {post.comments}
            </button>
            <button
              className="flex items-center gap-1.5 text-xs font-body text-muted-foreground hover:text-primary transition-colors"
              aria-label="Compartir"
            >
              <Share2 className="w-4 h-4" />
            </button>
          </div>
        </motion.article>
      ))}
    </section>
  );
}
