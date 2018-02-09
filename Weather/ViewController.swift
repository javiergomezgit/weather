//
//  ViewController.swift
//  11Weather
//
//  Created by Javier Gomez on 11/13/15.
//  Copyright © 2015 Javier Gomez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var cityText: UITextField!
    @IBOutlet var weatherLabel: UILabel!
    
    @IBOutlet var testing: UILabel!
    
    @IBAction func cityButton(sender: AnyObject)
    {
        self.view.endEditing(true)
        
        //variable para guardar la ciudad introducida
        var place:String = cityText.text!
        //variable para saber que fue exitosa la busqueda
        var exitoso = false
        //si funciona la direccion url la asiganra a la variable tryUrl
        place = place.stringByReplacingOccurrencesOfString(" ", withString: "-")
        let tryUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + place + "/forecasts/latest")
        
        //si encuentra una ciudad o una direccion correcta lo asignara a url
        if let url = tryUrl
        {
            //asignamos la pagina cargada a task
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                //convertimos la sesion task a NSString y lo asignamos a webContent
                let webContent = NSString(data: data!, encoding:NSUTF8StringEncoding)
                //buscamos una cadena similar, separamos por cadenas asignando a un arreglo
                let searchArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
            
                //de ese arreglo asignado si es mayor a 1 quiere decir que hay dos cadenas
                if searchArray.count > 1
                {
                    //asignamos el resultado de buscar y separar cadenas donde encuentr </span>, lo buscamos en la segunda posicion del arreglo searchArray
                    let weatherArray = searchArray[1].componentsSeparatedByString("</span>")
                    if weatherArray.count > 1
                    {
                        //si se  cumpli se le asigna el valor verdadero a exitoso, para usarlo posteriormente
                        exitoso = true
                        //lo que se encuentre en el arreglo weatherArray en la posicion cero cuando tenga el simbolo &deg sustituyelo por grados, asigna a variable summary
                        let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                        
                        dispatch_async(dispatch_get_main_queue(), {() -> Void in
                            //imprime el valor de watherSummary y conviertolo a strin para que la etiqueta lo pueda leer
                            self.weatherLabel.alpha = 1
                            self.weatherLabel.text = String(weatherSummary)
                        })
                    }
                }
            }
            
            if exitoso == false
            {
                self.weatherLabel.alpha = 0.8
                self.weatherLabel.text = "We  couln't find the typed city"
            }
            
            task.resume()
        }
        
        else
        {
            self.weatherLabel.alpha = 0.8
            self.weatherLabel.text = "We  couln't find the typed city"
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.cityText.delegate = self


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //diciendo que es verdad que la edicion(teclado) se cerrara
        self.view.endEditing(true)
    }
    
    //para que al presionar el boton return se esconda el teclado usamos esta funcion
    func textFieldShouldReturn(textField: UITextField!) -> Bool
    {
        cityText.resignFirstResponder()
        
        return true
    }



}


