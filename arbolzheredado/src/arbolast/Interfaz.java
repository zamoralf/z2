/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package arbolast;

import java.io.Reader;
import java.io.StringReader;
import java.util.Objects;
import java_cup.runtime.ComplexSymbolFactory;

/**
 *
 * @author herman
 */
public class Interfaz extends javax.swing.JFrame {

    private ListaVariables variables;
    private Nodo instrucciones;
    private String salida;
    
    /**
     * Creates new form Interfaz
     */
    public Interfaz() {
        initComponents();
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        jTextArea1 = new javax.swing.JTextArea();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTextArea2 = new javax.swing.JTextArea();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jButton1 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jTextArea1.setColumns(20);
        jTextArea1.setRows(5);
        jTextArea1.setText("/*calculo de 0 + 1 + 2 + ... + n - 2 + n - 1 + n,\npara un entero n*/\nn = 5\nb = 1\ni = 0\nwhile b < n + 1\n    i = i + b\n    b = b + 1\nend\nimprimir concat(\"sum( n = \", n, \" ) = \", i)\n");
        jTextArea1.setToolTipText("");
        jScrollPane1.setViewportView(jTextArea1);

        jTextArea2.setEditable(false);
        jTextArea2.setColumns(20);
        jTextArea2.setRows(5);
        jScrollPane2.setViewportView(jTextArea2);

        jLabel1.setText("Codigo de entrada:");

        jLabel2.setText("Codigo de salida:");

        jButton1.setText("Compilar");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButton1)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 387, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel1)))
                .addGap(30, 30, 30)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addGap(0, 0, Short.MAX_VALUE))
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 406, Short.MAX_VALUE))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(28, 28, 28)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(jLabel2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 327, Short.MAX_VALUE)
                    .addComponent(jScrollPane2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton1)
                .addContainerGap(27, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        
        try {
            Reader reader = new StringReader(jTextArea1.getText());
            AnalisisLexico scanner = new AnalisisLexico(reader);
            ComplexSymbolFactory sf = new ComplexSymbolFactory();
            scanner.setSymbolFactory(sf);
            AnalisisSintactico parser = new AnalisisSintactico(scanner,sf);
            parser.parse();
            variables = new ListaVariables();
            salida = "";
            instrucciones = parser.instrucciones;
            ejecutar(instrucciones);
            jTextArea2.setText(salida);            
        } catch (Exception exception) {
            System.out.println(exception.getMessage());
        }
        
    }//GEN-LAST:event_jButton1ActionPerformed

   private void ejecutar(Nodo instrucciones) throws Exception {
        int i = 0;
        Nodo instruccion;
        while (i < instrucciones.hijos.size()) {
            instruccion = instrucciones.hijos.get(i);
            if (instruccion.valor.equals("asignacion")) {
                String id = instruccion.hijos.get(0).hijos.get(0).valor;
                Object val = evaluarExpresion(instruccion.hijos.get(1));
                Variable var = new Variable();
                var.nombre = id;
                var.valor = val;
                variables.agregar(var);
            } 
            
            
            else if (instruccion.valor.equals("for")) {
            // Lógica para for
            String id = instruccion.hijos.get(0).hijos.get(0).valor;
            Object valInicial = evaluarExpresion(instruccion.hijos.get(1));
            Variable var = new Variable();
            var.nombre = id;
            var.valor = valInicial;
            variables.agregar(var);

            while ((Boolean) evaluarExpresion(instruccion.hijos.get(2))) {
                ejecutar(instruccion.hijos.get(4));

                Object incremento = evaluarExpresion(instruccion.hijos.get(3));
                var.valor = incremento;
                variables.agregar(var);
            }
            
            
           } 
            
            
            else if (instruccion.valor.equals("if")) {
                if ((Boolean) evaluarExpresion(instruccion.hijos.get(0))) {
                    ejecutar(instruccion.hijos.get(1));
                } else {
                    if (instruccion.hijos.size() == 3) {
                        ejecutar(instruccion.hijos.get(2));
                    }
                }
            } 
            
            
            else if (instruccion.valor.equals("do-while")){
                Nodo cuerpo = instruccion.hijos.get(0);
                Nodo condicion = instruccion.hijos.get(1);
                ejecutar(cuerpo);

                while ((Boolean) evaluarExpresion(condicion)) {
                    ejecutar(cuerpo);
                }
            }
            
            
            else if (instruccion.valor.equals("switch")) {
    Object switchValue = evaluarExpresion(instruccion.hijos.get(0)); // Evaluar la expresión del switch
    Nodo casos = instruccion.hijos.get(1); // Obtener la lista de casos
    boolean coincidenciaEncontrada = false;
    Nodo casoDefault = null;

    // Buscar casos que coincidan
    for (Nodo caso : casos.hijos) {
        if (caso.valor.equals("caso")) {
            Object casoValue = evaluarExpresion(caso.hijos.get(0)); // Evaluar el valor del caso

            if (!coincidenciaEncontrada && switchValue.equals(casoValue)) {
                ejecutar(caso.hijos.get(1)); // Ejecutar las instrucciones del caso
                coincidenciaEncontrada = true;
            }
        } else if (caso.valor.equals("default")) {
            casoDefault = caso; // Guardar el caso default
        }
    }

    // Si no hubo coincidencias, ejecutar el caso default si existe
    if (!coincidenciaEncontrada && casoDefault != null) {
        ejecutar(casoDefault.hijos.get(0)); // Ejecutar las instrucciones del caso default
    }
}
            
            else if (instruccion.valor.equals("while")) {
                while ((Boolean) evaluarExpresion(instruccion.hijos.get(0))) {
                    ejecutar(instruccion.hijos.get(1));
                }
            } else if (instruccion.valor.equals("imprimir")) {
                salida += evaluarExpresion(instruccion.hijos.get(0))+"\n";
            }
            i++;
        }
    }

    private Object evaluarExpresion(Nodo nodo) throws Exception {
        Nodo aux = nodo.hijos.get(0);
        switch (nodo.valor) {
            case "valor":
                if (aux.valor.equals("entero")) {
                    return Integer.valueOf(aux.hijos.get(0).valor);
                } else {
                    return aux.hijos.get(0).valor;
                }
            case "variable":
                Variable var = variables.buscar(aux.valor);
                if (var == null) {
                    throw new Exception("No se ha declarado la variable");
                } else {
                    return var.valor;
                }
            case "concatenar":
                String t = "";
                for (int i = 0; i < aux.hijos.size(); i++) {
                    t += String.valueOf(evaluarExpresion(aux.hijos.get(i)));
                }
                return t;
            case "and":
            {
                Boolean primera = (Boolean) evaluarExpresion(nodo.hijos.get(0));
                Boolean segunda = (Boolean) evaluarExpresion(nodo.hijos.get(1));
                return primera == true && segunda == true;
            }
            case "or":
            {
                Boolean primera = (Boolean) evaluarExpresion(nodo.hijos.get(0));
                Boolean segunda = (Boolean) evaluarExpresion(nodo.hijos.get(1));
                return primera == true || segunda == true;
            }
            case "not":
                return !(Boolean) evaluarExpresion(nodo.hijos.get(0));
            case "==":
            {
                Object primera = evaluarExpresion(nodo.hijos.get(0));
                Object segunda = evaluarExpresion(nodo.hijos.get(1));
                if (primera instanceof Integer) {
                    return Objects.equals((Integer) primera, (Integer) segunda);
                } else if (primera instanceof String) {
                    return ((String) primera).equals((String) segunda);
                } else if (primera instanceof Boolean) {
                    return Objects.equals((Boolean) primera, (Boolean) segunda);
                } else {
                    throw new Exception("No se reconoce el nodo");
                }
            }
            case "<":
            {
                Object primera = evaluarExpresion(nodo.hijos.get(0));
                Object segunda = evaluarExpresion(nodo.hijos.get(1));
                if (primera instanceof Integer) {
                    return (Integer) primera < (Integer) segunda;
                } else {
                    throw new Exception("No se reconoce el nodo");
                }
            }
            case ">":
            {
                Object primera = evaluarExpresion(nodo.hijos.get(0));
                Object segunda = evaluarExpresion(nodo.hijos.get(1));
                if (primera instanceof Integer) {
                    return (Integer) primera > (Integer) segunda;
                } else {
                    throw new Exception("No se reconoce el nodo");
                }
            }
            case "*":
            {
                Object primera = evaluarExpresion(nodo.hijos.get(0));
                Object segunda = evaluarExpresion(nodo.hijos.get(1));
                if (primera instanceof Integer) {
                    return (Integer) primera * (Integer) segunda;
                } else {
                    throw new Exception("No se reconoce el nodo");
                }
            }
            case "+":
            {
                Object primera = evaluarExpresion(nodo.hijos.get(0));
                Object segunda = evaluarExpresion(nodo.hijos.get(1));
                if (primera instanceof Integer) {
                    return (Integer) primera + (Integer) segunda;
                } else {
                    throw new Exception("No se reconoce el nodo");
                }
            }
            default:
                throw new Exception("No se reconoce el nodo");
        }
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTextArea jTextArea1;
    private javax.swing.JTextArea jTextArea2;
    // End of variables declaration//GEN-END:variables
}
