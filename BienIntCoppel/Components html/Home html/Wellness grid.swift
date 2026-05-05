//
//  Wellness grid.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { Link } from "react-router-dom";
import { Activity, Brain, Coins, Users } from "lucide-react";
import { motion } from "framer-motion";

const wellnessCards = [
  {
    title: "Bienestar Físico",
    description: "Activa tu cuerpo con rutinas personalizadas",
    icon: Activity,
    gradient: "from-orange-100 to-orange-50",
    iconBg: "bg-orange-400/15",
    iconColor: "text-orange-500",
    path: "/bienestar-fisico",

  },
  {
    title: "Bienestar Mental",
    description: "Gestiona tu estrés y cultiva tu equilibrio emocional",
    icon: Brain,
    gradient: "from-emerald-100 to-emerald-50",
    iconBg: "bg-emerald-400/15",
    iconColor: "text-emerald-500",
    path: "/bienestar-mental",
  },
  {
    title: "Bienestar Financiero",
    description: "Mejora tus finanzas y planifica tu futuro",
    icon: Coins,
    gradient: "from-amber-100 to-amber-50",
    iconBg: "bg-amber-400/15",
    iconColor: "text-amber-500",
    path: "/bienestar-financiero",
  },
  {
    title: "Bienestar Social",
    description: "Conecta con tu comunidad y fortalece tus lazos",
    icon: Users,
    gradient: "from-sky-100 to-sky-50",
    iconBg: "bg-sky-400/15",
    iconColor: "text-sky-500",
    path: "/bienestar-social",
  },
];

export default function WellnessGrid() {
  return (
    <section className="px-5 mt-6" aria-labelledby="wellness-title">
      <h2 id="wellness-title" className="text-lg font-heading font-bold text-foreground mb-4">
        Bienestar Integral
      </h2>
      <div className="grid grid-cols-2 gap-3">
        {wellnessCards.map((card, i) => (
          <motion.div
            key={card.title}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.08, duration: 0.4 }}
          >
            <Link
              to={card.path}
              className={`block rounded-2xl bg-gradient-to-br ${card.gradient} p-4 h-full border border-white/60 shadow-sm hover:shadow-md transition-all duration-300 hover:-translate-y-0.5`}
              aria-label={card.title}
            >
              <div className={`w-10 h-10 rounded-xl ${card.iconBg} flex items-center justify-center mb-3`}>
                <card.icon className={`w-5 h-5 ${card.iconColor}`} aria-hidden="true" />
              </div>
              <h3 className="text-sm font-heading font-bold text-foreground leading-tight">
                {card.title}
              </h3>
              <p className="text-[11px] font-body text-muted-foreground mt-1 leading-relaxed">
                {card.description}
              </p>
            </Link>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
