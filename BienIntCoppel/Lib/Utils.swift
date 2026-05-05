//
//  Utils.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

import { clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs) {
  return twMerge(clsx(inputs))
}


export const isIframe = window.self !== window.top;
