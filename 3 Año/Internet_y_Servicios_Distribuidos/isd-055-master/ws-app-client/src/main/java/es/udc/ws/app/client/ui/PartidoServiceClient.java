package es.udc.ws.app.client.ui;

import es.udc.ws.app.client.service.ClientPartidoService;
import es.udc.ws.app.client.service.ClientPartidoServiceFactory;
import es.udc.ws.app.client.service.dto.ClientPartidoDto;
import es.udc.ws.app.client.service.dto.ClientVentaDto;
import es.udc.ws.app.client.service.exceptions.ClientEntradaMarcadaException;
import es.udc.ws.app.client.service.exceptions.ClientEntradaNotAvaliableException;
import es.udc.ws.app.client.service.exceptions.ClientIncorrectTarjetaCreditoException;
import es.udc.ws.app.client.service.exceptions.ClientNotEnoughUnidadesException;
import es.udc.ws.app.model.PartidoService.exceptions.NotEnoughUnidadesException;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;

import java.time.LocalDateTime;
import java.util.List;

public class PartidoServiceClient {
    public static void main(String[] args) {
        if (args.length == 0) {
            printUsageAndExit();
        }
        ClientPartidoService clientPartidoService =
                ClientPartidoServiceFactory.getService();
        //System.out.println(args.length);
        if ("-addMatch".equalsIgnoreCase(args[0])) {
            validateArgs(args, 5, new int[]{});

            // [add] PartidoServiceClient -a <Equipo_visitante> <Fecha_del_partido>  <Precio> <Unidades Disponibles> <Entradas Vendidas>
            try {
                ClientPartidoDto partido =new ClientPartidoDto(null, args[1], LocalDateTime.parse(args[2]), Float.parseFloat(args[3]), Integer.parseInt(args[4]));
                Long partidoId = clientPartidoService.CrearPartido(partido);
                System.out.println("Partido " + partidoId + " created sucessfully");
            } catch (Exception ex) {
                ex.printStackTrace(System.err);
            }
        } else if ("-findMatch".equalsIgnoreCase(args[0])) {
            validateArgs(args, 2, new int[]{});

            // [find] PartidoServiceClient -f <PartidoId>
            try {
                ClientPartidoDto partidoDto = clientPartidoService.BuscarPartidoPorId(Long.valueOf(args[1]));
                System.out.println("Found match with id '" + args[1] + "':");
                System.out.println(partidoDto);
                System.out.println("\n");
            } catch (InstanceNotFoundException | NumberFormatException ex) {
                ex.printStackTrace(System.err);
            }
        } else if ("-findMatches".equalsIgnoreCase(args[0])) {
            validateArgs(args, 2, new int[]{});

            // [find] PartidoServiceClient -f <Fecha_Fin>
            try {
                System.out.println("Find match before '" + args[1] + "':");
                System.out.println(LocalDateTime.parse(args[1]));//LocalDateTime.parse(args[1]) fail, we pass as argument 2020-12-12T12:12:12
                List<ClientPartidoDto> partidoDto = clientPartidoService.BuscarPartidoPorFecha(LocalDateTime.parse(args[1]));
                System.out.println("Found matches" + ":");
                System.out.println(partidoDto);
                System.out.println("\n");
            } catch (InputValidationException ex) {
                ex.printStackTrace(System.err);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        } else if ("-buy".equalsIgnoreCase(args[0])) {
            validateArgs(args, 5, new int[]{});

            // [buy] PartidoServiceClient -buy <userEmail>  <cardNumber> <numTickets> <matchId>
            //"    [buy]    PartidoServiceClient -buy <matchId> <userEmail> <numTickets> <cardNumber>  \n"
            try {
                //Long ventaId = clientPartidoService.ComprarEntradas(args[1], args[2], Integer.parseInt(args[3]), Long.valueOf(args[4]));
                Long ventaId = clientPartidoService.ComprarEntradas(args[2], args[4], Integer.parseInt(args[3]), Long.valueOf(args[1]));
                System.out.println("Venta " + ventaId + " created sucessfully");
            } catch (NumberFormatException | InputValidationException |
                     InstanceNotFoundException | ClientIncorrectTarjetaCreditoException | ClientNotEnoughUnidadesException |
                     ClientEntradaNotAvaliableException | NotEnoughUnidadesException ex) {
                ex.printStackTrace(System.err);
            }
        } else if ( "-findPurchases".equalsIgnoreCase(args[0])){
            validateArgs(args, 2, new int[]{});

            // [findPurchases] PartidoServiceClient -findPurchases <userEmail>
            try {
                List<ClientVentaDto> EntradaDto = clientPartidoService.Buscar_Todas_las_Compras_Usuario((args[1]));
                System.out.println("Found match with id '" + args[1] + "':");
                System.out.println(EntradaDto);//Mirar porque fecha de compra es null
                System.out.println("\n");
            } catch (InputValidationException ex) {
                ex.printStackTrace(System.err);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }else if ( "-collect".equalsIgnoreCase(args[0])) {
            validateArgs(args, 3, new int[]{});

            // [collect] PartidoServiceClient -collect <purchaseId> <cardNumber>
            try {
                ClientVentaDto EntradaDto = clientPartidoService.Marcar_Entrada(Long.parseLong(args[1]), args[2]);
                System.out.println("Found match with id '" + args[1] + "':");
                System.out.println(EntradaDto);//Mirar porque fecha de compra es null
                System.out.println("\n");
            } catch (ClientEntradaMarcadaException | InstanceNotFoundException | ClientIncorrectTarjetaCreditoException ex) {
                ex.printStackTrace(System.err);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }else if ( "-findPopularMatches".equalsIgnoreCase(args[0])) {
            validateArgs(args, 3, new int[]{1});

            // [find] PartidoServiceClient -findPopularMatches <numeroentradas> <Fecha_Fin>
            try {
                System.out.println("Found match with id '" + args[1] + "':");
                System.out.println(LocalDateTime.parse(args[2]));//LocalDateTime.parse(args[1]) fail, we pass as argument 2020-12-12T12:12:12
                List<ClientPartidoDto> partidoDto = clientPartidoService.BuscarPartidoPocasEntradas(Long.parseLong(args[1]), LocalDateTime.parse(args[2]));
                System.out.println("Found match with id '" + args[1] + "':");
                System.out.println(partidoDto);
                System.out.println("\n");
            }
            catch (InputValidationException ex) {
                ex.printStackTrace(System.err);
            }
            catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
        else if ( "-removeMatch".equalsIgnoreCase(args[0])) {
            validateArgs(args, 2, new int[]{1});

            // [collect] PartidoServiceClient -removeMatch <purchaseId>
            try {
                clientPartidoService.EliminarPartidoCelebrado(Long.parseLong(args[1]));
                //System.out.println("Entrada eliminada");
            } catch ( InstanceNotFoundException | InputValidationException ex) {
                ex.printStackTrace(System.err);
            }
            catch (Exception e) {
                throw new RuntimeException(e);
            }
        }

    }

    public static void validateArgs(String[] args, int expectedArgs,
                                    int[] numericArguments) {
        if(expectedArgs != args.length) {
            printUsageAndExit();
        }
        for(int i = 0 ; i< numericArguments.length ; i++) {
            int position = numericArguments[i];
            try {
                Double.parseDouble(args[position]);
            } catch(NumberFormatException n) {
                printUsageAndExit();
            }
        }
    }


    public static void printUsageAndExit() {
        printUsage();
        System.exit(-1);
    }

    public static void printUsage() {
        System.err.println("Usage:\n" +
                "    [addMatch] PartidoServiceClient -addMatch <Equipo_visitante> <Fecha_del_partido>  <Precio> <Unidades Disponibles> <Entradas Vendidas> \n" +
                "    [findMatch] PartidoServiceClient -findMatch <PartidoId>\n"+
                "    [findMatches] PartidoServiceClient -findMatches <Fecha_Fin>\n" +
                "    [buy]    PartidoServiceClient -buy <userEmail>  <cardNumber> <numTickets> <matchId>\n"+
                "    [buy]    PartidoServiceClient -buy <matchId> <userEmail> <numTickets> <cardNumber>  \n"+
                "    [findPurchases]    PartidoServiceClient -findPurchases <userEmail>\n" +
                "    [collect]    PartidoServiceClient -collect <purchaseId> <cardNumber>\n" +
                "    [findPopularMatches]    PartidoServiceClient -findPopularMatches <Numero entradas> <Fecha_Inicio> <Fecha_Fin> \n"+
                "    [remove]    PartidoServiceClient -removeMatch <PartidoId>\n"
                );
    }

}