//
//  Questionnaire.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { ClipboardList, ExternalLink } from "lucide-react";
import { Button } from "@/components/ui/button";

export default function Questionnaire() {
  return (
    <section className="px-5 mt-4" aria-labelledby="questionnaire-title">
      <div className="bg-gradient-to-r from-orange-50 to-emerald-50 rounded-2xl border border-orange-100/60 p-5">
        <div className="flex items-start gap-3">
          <div className="w-10 h-10 rounded-xl bg-white/70 flex items-center justify-center flex-shrink-0">
            <ClipboardList className="w-5 h-5 text-primary" aria-hidden="true" />
          </div>
          <div className="flex-1">
            <h3 id="questionnaire-title" className="text-sm font-heading font-bold text-foreground">
              Cuestionario de Seguimiento
            </h3>
            <p className="text-xs font-body text-muted-foreground mt-1 leading-relaxed">
              Ayuda a tu IA a predecir tus picos de estrés. Basado en investigación científica validada.
            </p>
            <a
              href="https://pmc.ncbi.nlm.nih.gov/articles/PMC7359652/"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1 text-[10px] font-body text-primary/70 mt-1 hover:text-primary transition-colors"
            >
              Ver estudio de referencia <ExternalLink className="w-3 h-3" />
            </a>
            <Button
              className="mt-3 w-full rounded-xl bg-gradient-to-r from-orange-400 to-emerald-400 text-white font-heading font-semibold text-sm hover:opacity-90 border-0"
              size="sm"
            >
              Responder Cuestionario
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}
