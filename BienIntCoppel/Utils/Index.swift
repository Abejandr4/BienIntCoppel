//
//  Index.swift
//  BienIntCoppel
//
//  Created by Dev Jr. 19 on 04/05/26.
//

export function createPageUrl(pageName: string) {
    return '/' + pageName.replace(/ /g, '-');
}
