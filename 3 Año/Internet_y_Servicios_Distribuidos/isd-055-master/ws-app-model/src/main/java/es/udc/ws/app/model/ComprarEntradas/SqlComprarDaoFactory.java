package es.udc.ws.app.model.ComprarEntradas;

import es.udc.ws.util.configuration.ConfigurationParametersManager;
public class SqlComprarDaoFactory {
    private final static String CLASS_NAME_PARAMETER = "SqlComprarDaoFactory.className";
    private static SqlComprarDao dao = null;

    private SqlComprarDaoFactory() {
    }

    @SuppressWarnings("rawtypes")
    private static SqlComprarDao getInstance() {
        try {
            String daoClassName = ConfigurationParametersManager
                    .getParameter(CLASS_NAME_PARAMETER);
            Class daoClass = Class.forName(daoClassName);
            return (SqlComprarDao) daoClass.getDeclaredConstructor().newInstance();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public synchronized static SqlComprarDao getDao() {

        if (dao == null) {
            dao = getInstance();
        }
        return dao;

    }



}
