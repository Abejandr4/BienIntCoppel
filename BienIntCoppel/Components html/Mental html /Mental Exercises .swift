//
//  Mental Exercises .swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { motion } from "framer-motion";
import { Flower2, Wind, Headphones, Play } from "lucide-react";

const exercises = [
  {
    title: "Meditación Guiada",
    benefit: "Reduce la ansiedad en 5 minutos",
    icon: Flower2,
    gradient: "from-violet-100 to-violet-50",
    iconColor: "text-violet-500",
    iconBg: "bg-violet-400/15",
    duration: "5 min",
  },
  {
    title: "Técnicas de Respiración",
    benefit: "Calma instantánea con respiración 4-7-8",
    icon: Wind,
    gradient: "from-sky-100 to-sky-50",
    iconColor: "text-sky-500",
    iconBg: "bg-sky-400/15",
    duration: "3 min",
  },
  {
    title: "Mindfulness Laboral",
    benefit: "Mejora tu enfoque y productividad",
    icon: Headphones,
    gradient: "from-emerald-100 to-emerald-50",
    iconColor: "text-emerald-500",
    iconBg: "bg-emerald-400/15",
    duration: "10 min",
  },
];

export default function MentalExercises() {
  return (
    <section className="px-5 mt-4" aria-labelledby="exercises-title">
      <h3 id="exercises-title" className="text-base font-heading font-bold text-foreground mb-3">
        Ejercicios de Cuidado Mental
      </h3>
      <div className="space-y-3">
        {exercises.map((ex, i) => (
          <motion.div
            key={ex.title}
            initial={{ opacity: 0, x: -16 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: i * 0.1, duration: 0.35 }}
          >
            <div className={`bg-gradient-to-r ${ex.gradient} rounded-2xl border border-white/60 p-4 flex items-center gap-3`}>
              <div className={`w-11 h-11 rounded-xl ${ex.iconBg} flex items-center justify-center flex-shrink-0`}>
                <ex.icon className={`w-5 h-5 ${ex.iconColor}`} aria-hidden="true" />
              </div>
              <div className="flex-1 min-w-0">
                <h4 className="text-sm font-heading font-bold text-foreground">{ex.title}</h4>
                <p className="text-[11px] font-body text-muted-foreground mt-0.5">{ex.benefit}</p>
                <span className="text-[10px] font-body text-muted-foreground/70">{ex.duration}</span>
              </div>
              <button
                className="w-9 h-9 rounded-full bg-white/80 flex items-center justify-center shadow-sm hover:shadow-md transition-all hover:scale-105"
                aria-label={`Empezar ${ex.title}`}
              >
                <Play className="w-4 h-4 text-foreground ml-0.5" fill="currentColor" />
              </button>
            </div>
          </motion.div>
        ))}
      </div>
    </section>
  );
}
