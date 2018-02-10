//
//  DrawingViewController.swift
//  Rocket.Chat
//
//  Created by Artur Rymarz on 10.02.2018.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

final class DrawingViewController: UIViewController {

    @IBAction private func closeDrawing() {
        navigationController?.popViewController(animated: true)
    }
}
