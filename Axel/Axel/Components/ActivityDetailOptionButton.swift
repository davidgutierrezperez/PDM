//
//  ActivityDetailOptionButton.swift
//  Axel
//
//  Created by David Gutierrez on 1/6/25.
//

import UIKit

/// Clase que representa un botón que permite el acceso a
/// una vista de detalle de una actividad
class ActivityDetailOptionButton: UIButton {
    
    /// Tipo de detalle al que permitirá acceso el botón
    let detailOption: ActivityDetailOptions
    
    /// Indica si el contenido del botón debe mostrarse subrayado
    private var isUnderline = false
    
    /// Constructor por defecto del botón. Se configura el tipo de detalle
    /// al que permitirá acceso.
    /// - Parameter detail: tipo de detalle.
    init(detail: ActivityDetailOptions){
        detailOption = detail
        
        super.init(frame: CGRect())
        
        setTitleColor(AppColors.statisticOptionLabel, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Activa o desactiva el subrayado del contenido en función del estado
    /// del botón.
    func toggleUnderline(){
        isUnderline.toggle()
        underlineTitle(isUnderline)
    }
    
    /// Activa o desactiva el subrayado del título del botón en función
    /// de lo indicado en el parámetro **underline**.
    /// - Parameter underline: indica si el título del botón debe subrayarse.
    private func underlineTitle(_ underline: Bool){
        guard let title = self.title(for: .normal) else { return }
        
        let attributes: [NSAttributedString.Key: Any] = underline
            ? [.underlineStyle: NSUnderlineStyle.single.rawValue,
               .foregroundColor: UIColor.white]
            : [.foregroundColor: AppColors.statisticOptionLabel]
        
        let attributedTitle = NSAttributedString(string: title, attributes: attributes)
        setAttributedTitle(attributedTitle, for: .normal)
    }

}
