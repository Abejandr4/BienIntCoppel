//
//  MentalWellness.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { Link } from "react-router-dom";
import { ArrowLeft, Brain } from "lucide-react";
import CompanyStats from "@/components/mental/CompanyStats";
import StressChart from "@/components/mental/StressChart";
import Questionnaire from "@/components/mental/Questionnaire";
import MentalExercises from "@/components/mental/MentalExercises";

export default function MentalWellness() {
  return (
    <div className="min-h-screen">
      {/* Header */}
      <div className="relative overflow-hidden rounded-b-3xl">
        <div className="absolute inset-0 bg-gradient-to-br from-emerald-400 via-emerald-300 to-orange-300 opacity-90" />
        <div className="relative px-5 pt-12 pb-6">
          <div className="flex items-center gap-3">
            <Link
              to="/"
              className="w-9 h-9 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center hover:bg-white/30 transition-colors"
              aria-label="Volver al inicio"
            >
              <ArrowLeft className="w-5 h-5 text-white" />
            </Link>
            <div className="flex items-center gap-2">
              <Brain className="w-5 h-5 text-white" aria-hidden="true" />
              <div>
                <h1 className="text-xl font-heading font-bold text-white">Bienestar Mental</h1>
                <p className="text-xs font-body text-white/80">Fase 1 — Identificación</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <CompanyStats />
      <StressChart />
      <Questionnaire />
      <MentalExercises />

      {/* Progress notice */}
      <div className="px-5 mt-6 mb-8">
        <div className="bg-gradient-to-r from-orange-50 via-amber-50 to-emerald-50 rounded-2xl border border-amber-100/60 p-4 text-center">
          <p className="text-xs font-body text-muted-foreground leading-relaxed">
            🌱 Identifica tus emociones ahora para cuidarte de manera autónoma después. Tu progreso activará la siguiente fase y cambiará el color del tema.
          </p>
        </div>
      </div>
    </div>
  );
}
