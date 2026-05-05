//
//  Questions.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { useState } from "react";
import { Send, Bot, HelpCircle } from "lucide-react";
import { Input } from "@/components/ui/input";
import { motion } from "framer-motion";

const faqItems = [
  { q: "¿Cómo funciona el acompañamiento AI?", a: "Nuestro asistente analiza tus patrones de estrés y te sugiere actividades personalizadas para mejorar tu bienestar." },
  { q: "¿Mis datos son privados?", a: "Sí, toda tu información es completamente confidencial y anónima. Solo tú puedes ver tus datos personales." },
  { q: "¿Cada cuánto debo responder el cuestionario?", a: "Recomendamos responder semanalmente para obtener predicciones más precisas de tus picos de estrés." },
  { q: "¿Puedo hablar con un profesional?", a: "Sí, desde la sección de Bienestar Mental puedes solicitar una sesión con un psicólogo certificado." },
];

export default function Questions() {
  const [expandedIdx, setExpandedIdx] = useState(null);

  return (
    <div className="min-h-screen">
      {/* Header */}
      <div className="relative overflow-hidden rounded-b-3xl">
        <div className="absolute inset-0 bg-gradient-to-br from-sky-400 via-sky-300 to-emerald-300 opacity-90" />
        <div className="relative px-5 pt-12 pb-6">
          <div className="flex items-center gap-3">
            <HelpCircle className="w-5 h-5 text-white" aria-hidden="true" />
            <div>
              <h1 className="text-xl font-heading font-bold text-white">Preguntas Frecuentes</h1>
              <p className="text-xs font-body text-white/80">Resuelve tus dudas</p>
            </div>
          </div>
        </div>
      </div>

      <section className="px-5 mt-6 space-y-3" aria-label="Preguntas frecuentes">
        {faqItems.map((item, i) => (
          <motion.div
            key={i}
            initial={{ opacity: 0, y: 12 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: i * 0.08 }}
          >
            <button
              onClick={() => setExpandedIdx(expandedIdx === i ? null : i)}
              className="w-full text-left bg-card rounded-2xl border border-border shadow-sm p-4 transition-all hover:shadow-md"
              aria-expanded={expandedIdx === i}
            >
              <div className="flex items-center justify-between gap-3">
                <p className="text-sm font-heading font-semibold text-foreground">{item.q}</p>
                <span className={`text-muted-foreground text-lg transition-transform ${expandedIdx === i ? "rotate-45" : ""}`}>+</span>
              </div>
              {expandedIdx === i && (
                <motion.p
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: "auto" }}
                  className="text-sm font-body text-muted-foreground mt-3 leading-relaxed"
                >
                  {item.a}
                </motion.p>
              )}
            </button>
          </motion.div>
        ))}
      </section>

      {/* Still have questions */}
      <div className="px-5 mt-6 mb-8">
        <div className="bg-gradient-to-r from-sky-50 to-emerald-50 rounded-2xl border border-sky-100/60 p-5 text-center">
          <Bot className="w-8 h-8 text-sky-500 mx-auto mb-2" aria-hidden="true" />
          <p className="text-sm font-heading font-bold text-foreground">¿Aún tienes dudas?</p>
          <p className="text-xs font-body text-muted-foreground mt-1">Pregunta directamente a tu Acompañante AI desde Home</p>
        </div>
      </div>
    </div>
  );
}
